//
//  CalendarVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarVc: BaseVC<VcCalendarLayout>, CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {
    
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
    private var selectedDate: TimeInterval = currentTimeMillis()
    private var error: Responses?
    private var mode = CalendarVc.modeEvent
    var shouldRefresh = false
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainingManager.trainingCallback = trainigCallback
        trainingManager.trainingDaysCallback = trainingDaysCallback
        
        eventManager.planEventCallback = eventCallback
        eventManager.eventDaysCallback = eventDaysCallback
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
        
        contentLayout!.cvCalendarView.calendarAppearanceDelegate = self
        contentLayout!.cvCalendarView.calendarDelegate = self
        contentLayout!.calendarMenuView.menuViewDelegate = self
        
        contentLayout!.segmentedControl.addTarget(self, action: #selector(setSegmentedItem), for: .valueChanged)
        contentLayout!.btnToday.target = self
        contentLayout!.btnToday.action = #selector(btnTodayClick)
        
        contentLayout!.btnAdd.target = self
        contentLayout!.btnAdd.action = #selector(addClick)
        
        contentLayout!.tableViewTraining.deleteCallback = self.deleteDataCallback
        contentLayout!.tableViewEvent.deleteCallback = self.deleteDataCallback
        
        contentLayout!.tableViewTraining.trainingClickCallback = { sumTrainings, position in
            startTrainingDetailsPagerVc(navController: self.navigationController!, sumTrainings: sumTrainings, position: position)
        }
        contentLayout!.tableViewEvent.rowClickCallback = { planEvent, position in
            startEventDetailsViewController(viewController: self, planEvent: planEvent)
        }
        
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
        contentLayout!.cvCalendarView.commitCalendarViewUpdate()
        contentLayout!.calendarMenuView?.commitMenuViewUpdate()
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
        contentLayout!.cvCalendarView?.contentController.refreshPresentedMonth()
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
        showProgressBarTraining(isShow: true)
        trainingManager.getTrainingDays()
    }
    
    func getEventDays() {
        showProgressBarEvent(isShow: true)
        eventManager.getEventDays()
    }
    
    private func initTrainingDays(trainingDays: [TimeInterval]) {
        self.trainingDaysList = trainingDays
        if self.mode == CalendarVc.modeTraining {
            contentLayout!.cvCalendarView?.contentController.refreshPresentedMonth()
            getTrainigsList()
        }
    }
    
    private func initEventDays(eventDays: [TimeInterval]) {
        self.eventDaysList = eventDays
        if self.mode == CalendarVc.modeEvent {
            contentLayout!.cvCalendarView?.contentController.refreshPresentedMonth()
            getEventList()
        }
    }
    
    private func getTrainigsList() {
        contentLayout!.tableViewTraining.dataList = nil
        
        var sessionIds = [Double]()
        
        if let trainingDaysValue = sessionIdList {
            for sessionId in trainingDaysValue {
                if DateFormatHelper.isSameDay(timeStamp1: sessionId, timeStamp2: selectedDate) {
                    sessionIds.append(sessionId)
                }
            }
        }
        
        if sessionIds.count > 0 {
            showProgressBarTraining(isShow: true)
            trainingManager.downloadTrainings(sessionIds: sessionIds)
        } else {
            showProgressBarTraining(isShow: false)
        }
        
        errorHandling()
    }
    
    private func getEventList() {
        contentLayout!.tableViewEvent.dataList = nil
        
        if hasData(listToCheck: eventDaysList) {
            let fromDate = DateFormatHelper.getZeroHour(timeStamp: selectedDate)
            let toDate = DateFormatHelper.get23Hour(timeStamp: selectedDate)
            
            showProgressBarEvent(isShow: true)
            eventManager.getEventByTimestamp(timestampFrom: fromDate, timestampTo: toDate)
        } else {
            showProgressBarEvent(isShow: false)
        }
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
    
    private func refreshTableViewTraining(sumTrainings: [SumTraining]?) {
        contentLayout!.tableViewTraining?.dataList = sumTrainings
    }
    
    private func refreshTableViewEvent(planEvents: [PlanEvent]?) {
        contentLayout!.tableViewEvent.dataList = planEvents
    }
    
    //MARK: callbacks
    private func trainingDaysCallback(data: [Double]?, error: Responses?) {
        showProgressBarTraining(isShow: false)
        
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
    
    private func trainigCallback(data: [SumTraining]?, error: Responses?) {
        showProgressBarTraining(isShow: false)
        if data != nil && data!.count > 0 {
            if isDataCorrectDay(timestamp: data![0].sessionId) {
                refreshTableViewTraining(sumTrainings: data!)
            }
        } else {
            refreshTableViewTraining(sumTrainings: nil)
        }
        
        initError(error: error)
    }
    
    private func eventDaysCallback(data: [Double]?, error: Responses?) {
        showProgressBarEvent(isShow: false)
        
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
    
    private func eventCallback(data: [PlanEvent]?, error: Responses?) {
        if data != nil && data!.count > 0 {
            if isDataCorrectDay(timestamp: data![0].event.timestamp) {
                refreshTableViewEvent(planEvents: data!)
                showProgressBarEvent(isShow: false)
            }
        }
        
        initError(error: error)
    }
    
    private func deleteDataCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            refreshContentWithMode()
        }
        initError(error: error)
    }
    
    private func isDataCorrectDay(timestamp: Double) -> Bool {
        return DateFormatHelper.isSameDay(timeStamp1: timestamp, timeStamp2: self.selectedDate)
    }
    
    private func initError(error: Responses?) {
        self.error = error
        
        if (error != nil) {
            showProgressBarEvent(isShow: false)
            showProgressBarTraining(isShow: false)
        }
        
        errorHandling()
    }
    
    //MARK: error
    private func errorHandling() {
        if let globalError = self.error {
            errorHandlingWithAlert(viewController: self, error: globalError)
        }
    }
    
    //MARK: buttons listeners
    @objc private func btnTodayClick() {
        contentLayout!.cvCalendarView?.toggleCurrentDayView()
    }
    
    //TODO: add showPlanType function
    @objc private func addClick() {
        startPlanTypeVc(viewController: self)
    }
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .monday
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        switch mode {
        case CalendarVc.modeEvent:
            if let eventDayList = eventDaysList {
                if eventDayList.contains(dayView.date.getTimeMillis()) {
                    return true
                }
            } else {
                return false
            }
        case CalendarVc.modeTraining:
            if let trainingDayList = trainingDaysList { 
                
                if trainingDayList.contains(dayView.date.getTimeMillis()) {
                    return true
                }
            } else {
                return false
            }
        default:
            return false
        }
        return false
    }
    
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
        return 10.0
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [Colors.colorAccent]
    }
    
    func dayLabelWeekdayInTextColor() -> UIColor {
        return Colors.colorWhite
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        refreshMonth(timeStamp: date.getTimeMillis())
        log("DATE", DateFormatHelper.getDate(dateFormat: "yyyy.mm.dd", timeIntervallSince1970: date.getTimeMillis()))
        
        if selectedDate != date.getTimeMillis() {
            selectedDate = date.getTimeMillis()
            
            switch mode {
            case CalendarVc.modeEvent:
                getEventList()
            case CalendarVc.modeTraining:
                getTrainigsList()
            default:
                break
            }
        }
    }
    
    private func refreshMonth(timeStamp: TimeInterval) {
        contentLayout!.labelMonth.text = DateFormatHelper.getDate(dateFormat: getString("date_format_month"), timeIntervallSince1970: timeStamp)
        contentLayout!.cvCalendarView.contentController.refreshPresentedMonth()
    }
    
    @objc private func setSegmentedItem(sender: UISegmentedControl) {
        let viewSub: UIView
        switch sender.selectedSegmentIndex {
        case 0:
            viewSub = contentLayout!.tableViewEvent
            setMode(mode: CalendarVc.modeEvent)
        default:
            viewSub = contentLayout!.tableViewTraining
            setMode(mode: CalendarVc.modeTraining)
        }
        
        contentLayout!.viewTableView.removeAllSubviews()
        contentLayout!.viewTableView.addSubview(viewSub)
        viewSub.snp.makeConstraints { make in
            make.edges.equalTo(contentLayout!.viewTableView)
        }
    }
    
    private func showProgressBarTraining(isShow: Bool) {
        showProgressBar(progressBar: contentLayout!.progressBarTraining, isShow: isShow)
    }
    
    private func showProgressBarEvent(isShow: Bool) {
        showProgressBar(progressBar: contentLayout!.progressBarEvent, isShow: isShow)
    }
    
    private func showProgressBar(progressBar: AppProgressBar, isShow: Bool) {
        progressBar.showProgressBar(isShow)
    }
}
