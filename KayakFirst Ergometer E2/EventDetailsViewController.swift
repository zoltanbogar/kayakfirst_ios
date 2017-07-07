//
//  EventDetailsViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func startEventDetailsViewController(viewController: UIViewController, plan: Plan) {
    let eventDetailsVc = EventDetailsViewController()
    eventDetailsVc.plan = plan
    
    let navVc = UINavigationController()
    navVc.pushViewController(eventDetailsVc, animated: false)
    viewController.present(navVc, animated: true, completion: nil)
}

class EventDetailsViewController: BaseVC {
    
    //MARK: properties
    var plan: Plan?
    var event: Event?
    
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
    
    //MARK: functions
    private func setEditLayout(isEdit: Bool) {
        if isEdit {
            if event != nil {
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
        if let eventValue = event {
            name = eventValue.name
            planType = eventValue.planType
            planId = eventValue.planId
            
            timestamp = eventValue.timestamp
            
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
            if self.event == nil {
                event = Event(
                    userId: UserManager.sharedInstance.getUser()!.id,
                    sessionId: 0,
                    timestamp: timestamp,
                    name: name!,
                    planType: planType!,
                    planId: planId!)
            } else {
                self.event?.timestamp = timestamp
                event = self.event
            }
            let managerType = EventManager.sharedInstance.saveEvent(event: event!, managerCallBack: eventSaveCallback)
            showProgress(baseManagerType: managerType)
            
            //TODO: setResult
            self.parent?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func btnDeleteClick() {
        if let eventValue = event {
            DeleteEventDialog.showDeleteTrainingDialog(viewController: self, event: eventValue, managerCallback: eventDeleteCallback)
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
        
        stackView.addArrangedSubview(etName)
        stackView.addArrangedSubview(etDate)
        stackView.addArrangedSubview(etStart)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = Date()
        timePickerView.datePickerMode = .time
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
        
        setEditLayout(isEdit: event == nil)
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
