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

class EventDetailsViewController: BaseVC<VcEventDetailsLayout>, UITextFieldDelegate {
    
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
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFields()
    }
    
    //MARK: functions
    private func setEditLayout(isEdit: Bool) {
        if isEdit {
            if planEvent != nil {
                setTabbarItem(tabbarItems: [contentLayout!.btnSave, contentLayout!.btnDelete])
            } else {
                setTabbarItem(tabbarItems: [contentLayout!.btnSave])
            }
        } else {
            if planEvent != nil && planEvent!.event.sessionId != 0 {
                setTabbarItem(tabbarItems: [])
            } else {
               setTabbarItem(tabbarItems: [contentLayout!.btnEdit])
            }
        }
        contentLayout!.etDate.active = isEdit
        contentLayout!.etStart.active = isEdit
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
        contentLayout!.etName.text = name
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
        contentLayout!.etDate.text = dateText
        contentLayout!.etStart.text = timeText
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
    
    //MARK: textview delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.inputView == contentLayout!.datePickerView {
            datePickerValueChanged(sender: contentLayout!.datePickerView)
        } else if textField.inputView == contentLayout!.timePickerView {
            datePickerValueChanged(sender: contentLayout!.timePickerView)
        }
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
                    userId: UserManager.sharedInstance.getUserId(),
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
        
        if self.parentVc != nil && self.parentVc is PlanDetailsViewController {
            self.dismiss(animated: true, completion:  {
                (self.parentVc! as! PlanDetailsViewController).eventSaved()
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
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
        super.initView()
        
        contentLayout?.btnSave.target = self
        contentLayout?.btnSave.action = #selector(btnSaveClick)
        contentLayout?.btnDelete.target = self
        contentLayout?.btnDelete.action = #selector(btnDeleteClick)
        contentLayout?.btnEdit.target = self
        contentLayout?.btnEdit.action = #selector(btnEditClick)
        
        contentLayout?.etDate.contentLayout!.valueTextField.inputView = contentLayout!.datePickerView
        contentLayout?.etDate.contentLayout!.valueTextField.delegate = self
        contentLayout?.datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        contentLayout?.etStart.contentLayout!.valueTextField.inputView = contentLayout!.timePickerView
        contentLayout?.etStart.contentLayout!.valueTextField.delegate = self
        contentLayout?.timePickerView.addTarget(self, action: #selector(self.timePickerValueChanged), for: UIControlEvents.valueChanged)
        
       initPickers()
    }
    
    override func getContentLayout(contentView: UIView) -> VcEventDetailsLayout {
        return VcEventDetailsLayout(contentView: contentView)
    }
    
    private func initPickers() {
        contentLayout?.datePickerView.datePickerMode = .date
        contentLayout?.datePickerView.minimumDate = Date()
        contentLayout?.timePickerView.datePickerMode = .time
        
        if let timestamp = planEvent?.event.timestamp {
            contentLayout?.datePickerView.date = Date(timeIntervalSince1970: timestamp / 1000)
            contentLayout?.timePickerView.date = Date(timeIntervalSince1970: timestamp / 1000)
        }
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
        
        setEditLayout(isEdit: planEvent == nil)
    }
}
