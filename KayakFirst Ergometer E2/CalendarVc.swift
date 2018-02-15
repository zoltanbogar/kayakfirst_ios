//
//  CalendarVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class CalendarVc: BaseVC<VcCalendarLayout>, CalendarDelegate {
    
    //MARK: constants
    private static let modeEvent = "mode_event"
    private static let modeTraining = "mode_training"
    
    //MARK: daysList
    private var trainingDaysList: [TimeInterval]?
    private var sessionIdList: [TimeInterval]?
    private var eventDaysList: [TimeInterval]?
    
    //MARK: manager
    private let trainingManager = TrainingManager.sharedInstance
    private let eventManager = EventManager.sharedInstance
    
    //MARK: properties
    private var selectedDate: TimeInterval = 0
    private var error: Responses?
    private var mode = CalendarVc.modeEvent
    var shouldRefresh = false
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainingManager.trainingDaysCallback = trainingDaysCallback
        
        eventManager.eventDaysCallback = eventDaysCallback
        
        contentLayout!.calendarView.delegate = self
        selectedDate = contentLayout!.calendarView.selectedDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mode == CalendarVc.modeEvent || shouldRefresh {
            shouldRefresh = false
             refreshContentWithMode()
        }
        
        WindowHelper.keepScreenOn(isOn: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        WindowHelper.keepScreenOn(isOn: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        refreshCalendarDesign()
    }
    
    internal override func initView() {
        super.initView()
        
        contentLayout!.segmentedControl.addTarget(self, action: #selector(setSegmentedItem), for: .valueChanged)
        contentLayout!.btnToday.target = self
        contentLayout!.btnToday.action = #selector(btnTodayClick)
        
        contentLayout!.btnAdd.target = self
        contentLayout!.btnAdd.action = #selector(addClick)
        
        contentLayout!.trainingListView.initTableView(calendarVc: self, clickCallback: trainingClick, deleteCallback: deleteDataCallback)
        contentLayout!.eventListView.initTableView(calendarVc: self, clickCallback: eventClick, deleteCallback: deleteDataCallback)
        
        contentLayout!.segmentedControl.selectedSegmentIndex = 0
        setSegmentedItem(sender: contentLayout!.segmentedControl)
    }
    
    override func getContentLayout(contentView: UIView) -> VcCalendarLayout {
        return VcCalendarLayout(contentView: contentView)
    }
    
    override func handlePortraitLayout(size: CGSize) {
        super.handlePortraitLayout(size: size)
        
        refreshCalendarDesign()
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        super.handleLandscapeLayout(size: size)
        
        refreshCalendarDesign()
    }
    
    private func refreshCalendarDesign() {
        contentLayout!.designCalendarView()
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems([
            contentLayout!.btnAdd,
            contentLayout!.btnToday], animated: true)
        showLogoOnLeft()
    }
    
    //MARK: call manager
    private func setMode(mode: String) {
        self.mode = mode
        refreshContentWithMode()
    }
    
    private func refreshContentWithMode() {
        contentLayout!.calendarView.timestamps = nil
        switch mode {
        case CalendarVc.modeEvent:
            getEventDays()
        case CalendarVc.modeTraining:
            getTrainingDays()
        default:
            break
        }
    }
    
    func getTrainingDays() {
        trainingManager.getTrainingDays()
    }
    
    func getEventDays() {
        eventManager.getEventDays()
    }
    
    private func initTrainingDays(trainingDays: [TimeInterval]) {
        self.trainingDaysList = trainingDays
        if self.mode == CalendarVc.modeTraining {
            contentLayout!.calendarView.timestamps = trainingDays
            
            getTrainigsList()
        }
    }
    
    private func initEventDays(eventDays: [TimeInterval]) {
        self.eventDaysList = eventDays
        if self.mode == CalendarVc.modeEvent {
            contentLayout!.calendarView.timestamps = eventDays
            
            getEventList()
        }
    }
    
    private func getTrainigsList() {
        var sessionIds = [Double]()
        
        if let trainingDaysValue = sessionIdList {
            for sessionId in trainingDaysValue {
                if DateFormatHelper.isSameDay(timeStamp1: sessionId, timeStamp2: selectedDate) {
                    sessionIds.append(sessionId)
                }
            }
        }
        
        contentLayout!.trainingListView.showData(timestamps: sessionIds, selectedDate: selectedDate)
        
        errorHandling()
    }
    
    private func getEventList() {
        var timestamps = [Double]()
        if hasData(listToCheck: eventDaysList) {
            let fromDate = DateFormatHelper.getZeroHour(timeStamp: selectedDate)
            let toDate = DateFormatHelper.get23Hour(timeStamp: selectedDate)
            
            timestamps.append(fromDate)
            timestamps.append(toDate)
        }
        
        contentLayout!.eventListView.showData(timestamps: timestamps, selectedDate: selectedDate)
        
        errorHandling()
    }
    
    private func hasData(listToCheck: [Double]?) -> Bool {
        var hasData = false
        
        if let list = listToCheck {
            for d in list {
                hasData = DateFormatHelper.isSameDay(timeStamp1: d, timeStamp2: selectedDate)
                
                if hasData {
                    break
                }
            }
        }
        return hasData
    }
    
    //MARK: callbacks
    func onDateSelected(timestamp: Double) {
        selectedDate = timestamp
        
        switch mode {
        case CalendarVc.modeEvent:
            getEventList()
        case CalendarVc.modeTraining:
            getTrainigsList()
        default:
            break
        }
    }
    
    private func trainingDaysCallback(data: [Double]?, error: Responses?) {
        self.sessionIdList = data
        
        var trainingDays = [Double]()
        
        if let dataValue = data {
            for trainingDay in dataValue {
                let zeroTrainingDay = DateFormatHelper.getZeroHour(timeStamp: trainingDay)
                 
                 if !trainingDays.contains(zeroTrainingDay) {
                 trainingDays.append(zeroTrainingDay)
                 }
            }
            
            initTrainingDays(trainingDays: trainingDays)
        }
        
        initError(error: error)
    }
    
    private func eventDaysCallback(data: [Double]?, error: Responses?) {
        var eventDays = [Double]()
        
        if let dataValue = data {
            for eventDay in dataValue {
                let zeroTrainingDay = DateFormatHelper.getZeroHour(timeStamp: eventDay)
                
                if !eventDays.contains(zeroTrainingDay) {
                    eventDays.append(zeroTrainingDay)
                }
            }
            
            initEventDays(eventDays: eventDays)
        }
        
        initError(error: error)
    }
    
    private func trainingClick(data: [SumTrainingNew]?, position: Int) {
        startTrainingDetailsPagerVc(navController: self.navigationController!, sumTrainings: data, position: position)
    }
    
    private func eventClick(data: [PlanEvent]?, position: Int) {
        let planEvent = data![position]
        startEventDetailsViewController(viewController: self, planEvent: planEvent)
    }
    
    private func deleteDataCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            refreshContentWithMode()
        }
        initError(error: error)
    }
    
    func initError(error: Responses?) {
        self.error = error
        
        errorHandling()
    }
    
    //MARK: error
    private func errorHandling() {
        if let globalError = self.error {
            errorHandlingWithToast(viewController: self, error: globalError)
        }
    }
    
    //MARK: buttons listeners
    @objc private func btnTodayClick() {
        contentLayout!.calendarView.setToday()
    }
    
    @objc private func addClick() {
        startPlanTypeVc(viewController: self)
    }
    
    @objc private func setSegmentedItem(sender: UISegmentedControl) {
        let viewSub: UIView
        switch sender.selectedSegmentIndex {
        case 0:
            viewSub = contentLayout!.eventListView
            setMode(mode: CalendarVc.modeEvent)
        default:
            viewSub = contentLayout!.trainingListView
            setMode(mode: CalendarVc.modeTraining)
        }
        
        contentLayout!.viewTableView.removeAllSubviews()
        contentLayout!.viewTableView.addSubview(viewSub)
        viewSub.snp.makeConstraints { make in
            make.edges.equalTo(contentLayout!.viewTableView)
        }
    }
}
