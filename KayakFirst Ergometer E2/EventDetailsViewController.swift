//
//  EventDetailsViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func startEventDetailsViewController(viewController: UIViewController, plan: Plan) {
    startEventDetailsViewController(viewController: viewController, planEvent: nil, plan: plan)
}

func startEventDetailsViewController(viewController: UIViewController, planEvent: PlanEvent) {
    startEventDetailsViewController(viewController: viewController, planEvent: planEvent, plan: nil)
}

func startEventDetailsViewController(viewController: UIViewController, planEvent: PlanEvent?, plan: Plan?) {
    let eventDetailsVc = EventDetailsViewController()
    eventDetailsVc.plan = plan
    eventDetailsVc.planEvent = planEvent
    eventDetailsVc.parentVc = viewController
    
    let navVc = PortraitNavController()
    navVc.pushViewController(eventDetailsVc, animated: false)
    viewController.present(navVc, animated: true, completion: nil)
}

class EventDetailsViewController: BaseVC {
    
    //MARK: properties
    var plan: Plan?
    var planEvent: PlanEvent?
    
    var parentVc: UIViewController?
    
    private var year: Int = 0
    private var month: Int = 0
    private var day: Int = 0
    private var hour: Int = -1
    private var minute: Int = -1
    private var timestamp: Double = 0
    
    private var name: String?
    private var planType: PlanType?
    private var planId: String?
    
    private var datePickerView = UIDatePicker()
    private var timePickerView = UIDatePicker()
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFields()
    }
    
    //MARK: functions
    private func setEditLayout(isEdit: Bool) {
        if isEdit {
            if planEvent != nil {
                setTabbarItem(tabbarItems: [btnSave, btnDelete])
            } else {
                setTabbarItem(tabbarItems: [btnSave])
            }
        } else {
            setTabbarItem(tabbarItems: [btnEdit])
        }
        etDate.active = isEdit
        etStart.active = isEdit
    }
    
    private func initFields() {
        if let eventValue = planEvent {
            name = planEvent?.plan.name
            planType = eventValue.plan.type
            planId = eventValue.plan.planId
            
            timestamp = eventValue.event.timestamp
            
            setTimestampText()
        } else {
            name = plan?.name
            planType = plan?.type
            planId = plan?.planId
        }
        etName.text = name
    }
    
    private func setTimestampText() {
        var dateText = ""
        var timeText = ""
        if timestamp != 0 {
            dateText = DateFormatHelper.getDate(dateFormat: DateFormatHelper.dateFormat, timeIntervallSince1970: timestamp)
            timeText = DateFormatHelper.getDate(dateFormat: DateFormatHelper.timeFormat, timeIntervallSince1970: timestamp)
            
            let date = Date(timeIntervalSince1970: timestamp/1000)
            let calendar = Calendar.current
            initDateComponents(calendar: calendar, date: date)
            initTimeComponents(calendar: calendar, date: date)
        }
        etDate.text = dateText
        etStart.text = timeText
    }
    
    private func initDateComponents(calendar: Calendar, date: Date) {
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
    }
    
    private func initTimeComponents(calendar: Calendar, date: Date) {
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
    }
    
    private func setTimestamp() {
        if year == 0 && month == 0 && day == 0 {
            let date = Date(timeIntervalSince1970: currentTimeMillis()/1000)
            let calendar = Calendar.current
            initDateComponents(calendar: calendar, date: date)
        }
        
        if hour == -1 && minute == -1 {
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.hour = Event.defaultHour
            dateComponents.minute = 0
            initTimeComponents(calendar: calendar, date: calendar.date(from: dateComponents)!)
        }
        
        timestamp = DateFormatHelper.getTimestampByDate(year: year, month: month, day: day, hour: hour, minute: minute)
        
        setTimestampText()
    }
    
    //MARK: picker listener
    func datePickerValueChanged(sender: UIDatePicker) {
        let timestamp = DateFormatHelper.getTimestampFromDatePicker(datePicker: sender)
        let date = Date(timeIntervalSince1970: timestamp/1000)
        let calendar = Calendar.current
        
        initDateComponents(calendar: calendar, date: date)
        
        setTimestamp()
    }
    
    func timePickerValueChanged(sender: UIDatePicker) {
        let timestamp = DateFormatHelper.getMilliSeconds(date: sender.date)
        let date = Date(timeIntervalSince1970: timestamp/1000)
        let calendar = Calendar.current
        
        initTimeComponents(calendar: calendar, date: date)
        
        setTimestamp()
    }
    
    //MARK: barbutton listeners
    @objc private func btnSaveClick() {
        if Validate.isEventTimestampValid(viewController: self, timestamp: timestamp) {
            var event: Event? = nil
            if self.planEvent == nil {
                event = Event(
                    userId: UserManager.sharedInstance.getUser()!.id,
                    sessionId: 0,
                    timestamp: timestamp,
                    name: name!,
                    planType: planType!,
                    planId: planId!)
            } else {
                self.planEvent?.event.timestamp = timestamp
                event = self.planEvent?.event
            }
            let managerType = EventManager.sharedInstance.saveEvent(event: event!, managerCallBack: eventSaveCallback)
            showProgress(baseManagerType: managerType)
            
            if self.parentVc != nil && self.parentVc is PlanDetailsViewController {
                self.dismiss(animated: true, completion:  {
                    (self.parentVc! as! PlanDetailsViewController).eventSaved()
                })
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc private func btnDeleteClick() {
        if let eventValue = planEvent {
            DeleteEventDialog.showDeleteEventDialog(viewController: self, planEvent: eventValue, managerCallback: eventDeleteCallback)
        }
    }
    
    @objc private func btnEditClick() {
        setEditLayout(isEdit: true)
    }
    
    //MARK: manager callback
    private func eventSaveCallback(data: Bool?, error: Responses?) {
        dismissProgress()
    }
    
    private func eventDeleteCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            self.parent?.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: helper
    private func setTabbarItem(tabbarItems: [UIBarButtonItem]) {
        self.navigationItem.setRightBarButtonItems(tabbarItems, animated: true)
    }
    
    //MARK: init view
    override func initView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = margin
        
        stackView.addArrangedSubview(labelTitle)
        stackView.addArrangedSubview(etDate)
        stackView.addArrangedSubview(etStart)
        stackView.addArrangedSubview(etName)
        
        labelTitle.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.width.equalTo(200)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
       initPickers()
    }
    
    private func initPickers() {
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = Date()
        timePickerView.datePickerMode = .time
        
        if let timestamp = planEvent?.event.timestamp {
            datePickerView.date = Date(timeIntervalSince1970: timestamp / 1000)
            timePickerView.date = Date(timeIntervalSince1970: timestamp / 1000)
        }
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
        
        setEditLayout(isEdit: planEvent == nil)
    }
    
    //MARK: views
    lazy var etName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("plan_name")
        textField.active = false
        
        return textField
    }()
    
    private lazy var etDate: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("date_date")
        textField.active = false
        
        textField.valueTextField.inputView = self.datePickerView
        self.datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        return textField
    }()
    
    private lazy var etStart: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("training_start")
        textField.active = false
        
        textField.valueTextField.inputView = self.timePickerView
        self.timePickerView.addTarget(self, action: #selector(self.timePickerValueChanged), for: UIControlEvents.valueChanged)
        
        return textField
    }()
    
    private lazy var labelTitle: AppUILabel! = {
        let label = AppUILabel()
        
        label.textAlignment = .center
        label.text = getString("plan_event_title")
        label.numberOfLines = 0
        
        return label
    }()
    
    //MARK: barbuttons
    private lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "save")
        button.target = self
        button.action = #selector(btnSaveClick)
        
        return button
    }()
    
    private lazy var btnDelete: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "trash")
        button.target = self
        button.action = #selector(btnDeleteClick)
        
        return button
    }()
    
    private lazy var btnEdit: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "edit")
        button.target = self
        button.action = #selector(btnEditClick)
        
        return button
    }()
}
