//
//  CalendarVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarVc: MainTabVc, CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {
    
    //MARK: constants
    private let segmentItems = [getString("plan_plan"), getString("training_log").capitalized]
    private let calendarHeight: CGFloat = 190
    private static let modeEvent = "mode_event"
    private static let modeTraining = "mode_training"
    
    //MARK: views
    private var stackView: UIStackView?
    private let viewTableView = UIView()
    private let viewCalendar = UIView()
    
    //MARK: daysList
    private var trainingDaysList: [TimeInterval]?
    private var eventDaysList: [TimeInterval]?
    
    //MARK: manager
    private let trainingManager = TrainingManager.sharedInstance
    private let eventManager = EventManager.sharedInstance
    
    //MARK: properties
    private var selectedDate: TimeInterval?
    private var error: Responses?
    private var mode = CalendarVc.modeEvent
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainingManager.trainingCallback = trainigCallback
        trainingManager.trainingDaysCallback = trainingDaysCallback
        
        eventManager.planEventCallback = eventCallback
        eventManager.eventDaysCallback = eventDaysCallback
        
        segmentedControl.selectedSegmentIndex = 0
        setSegmentedItem(sender: segmentedControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshContentWithMode()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        refreshCalendarDesign()
    }
    
    internal override func initView() {
        stackView = UIStackView()
        stackView?.distribution = .fillEqually
        stackView?.spacing = margin
        
        viewCalendar.addSubview(cvCalendarView)
        viewCalendar.addSubview(labelMonth)
        viewCalendar.addSubview(calendarMenuView)
        viewCalendar.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.width.equalTo(viewCalendar).offset(-2 * margin2)
            make.centerX.equalTo(viewCalendar)
            make.top.equalTo(viewCalendar).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
        }
        labelMonth.snp.makeConstraints { (make) in
            make.width.equalTo(viewCalendar)
            make.top.equalTo(segmentedControl.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin05, 0))
        }
        
        stackView?.addArrangedSubview(viewCalendar)
        stackView?.addArrangedSubview(viewTableView)
        
        let offset = UIScreen.main.bounds.height >= 600 ? (margin2 * 2) : -margin
        
        viewTableView.snp.makeConstraints { (make) in
            make.height.equalTo(cvCalendarView).offset(offset)
        }
        
        contentView.addSubview(stackView!)
        stackView?.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        tableViewTraining.addSubview(progressBarTraining)
        progressBarTraining.snp.makeConstraints { make in
            make.center.equalTo(tableViewTraining)
        }
        tableViewEvent.addSubview(progressBarEvent)
        progressBarEvent.snp.makeConstraints { (make) in
            make.center.equalTo(tableViewEvent)
        }
    }
    
    override func handlePortraitLayout(size: CGSize) {
        stackView?.axis = .vertical
        
        let width: CGFloat = size.width
        let height: CGFloat = calendarHeight
        
        cvCalendarView.frame = CGRect(x: 0, y: 100, width: width, height: height)
        calendarMenuView.frame = CGRect(x: 0, y: 75, width: width, height: 20)
        
        refreshCalendarDesign()
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        stackView?.axis = .horizontal
        
        let width: CGFloat = size.width / 2
        let height: CGFloat = calendarHeight
        
        cvCalendarView.frame = CGRect(x: 0, y: 90, width: width, height: height)
        calendarMenuView.frame = CGRect(x: 0, y: 75, width: width, height: 20)
        
        refreshCalendarDesign()
    }
    
    private func refreshCalendarDesign() {
        cvCalendarView.commitCalendarViewUpdate()
        calendarMenuView?.commitMenuViewUpdate()
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems([btnAdd, btnToday], animated: true)
        showLogoOnLeft()
    }
    
    //MARK: call manager
    private func setMode(mode: String) {
        self.mode = mode
        refreshContentWithMode()
    }
    
    private func refreshContentWithMode() {
        cvCalendarView?.contentController.refreshPresentedMonth()
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
    
    private func initTrainingDays(trainingDays: [TimeInterval]?) {
        self.trainingDaysList = trainingDays
        if self.mode == CalendarVc.modeTraining {
            cvCalendarView?.contentController.refreshPresentedMonth()
            getTrainigsList()
        }
    }
    
    private func initEventDays(eventDays: [TimeInterval]?) {
        self.eventDaysList = eventDays
        if self.mode == CalendarVc.modeEvent {
            cvCalendarView?.contentController.refreshPresentedMonth()
            getEventList()
        }
    }
    
    private func getTrainigsList() {
        tableViewTraining.dataList = nil
        
        if hasData(listToCheck: trainingDaysList) {
            let fromDate = DateFormatHelper.getZeroHour(timeStamp: selectedDate!)
            let toDate = DateFormatHelper.get23Hour(timeStamp: selectedDate!)
            
            showProgressBarTraining(isShow: true)
            trainingManager.downloadTrainings(sessionIdFrom: fromDate, sessionIdTo: toDate)
        }
        errorHandling()
    }
    
    private func getEventList() {
        tableViewEvent.dataList = nil
        
        if hasData(listToCheck: eventDaysList) {
            let fromDate = DateFormatHelper.getZeroHour(timeStamp: selectedDate!)
            let toDate = DateFormatHelper.get23Hour(timeStamp: selectedDate!)
            
            showProgressBarEvent(isShow: true)
            eventManager.getEventByTimestamp(timestampFrom: fromDate, timestampTo: toDate)
        }
        errorHandling()
    }
    
    private func hasData(listToCheck: [Double]?) -> Bool {
        var hasData = false
        
        if let list = listToCheck {
            for d in list {
                hasData = DateFormatHelper.isSameDay(timeStamp1: d, timeStamp2: selectedDate!)
                
                if hasData {
                    break
                }
            }
        }
        return hasData
    }
    
    private func refreshTableViewTraining(sumTrainings: [SumTraining]?) {
        tableViewTraining?.dataList = sumTrainings
    }
    
    private func refreshTableViewEvent(planEvents: [PlanEvent]?) {
        tableViewEvent.dataList = planEvents
    }
    
    //MARK: callbacks
    private func trainingDaysCallback(data: [Double]?, error: Responses?) {
        initTrainingDays(trainingDays: data)
        
        initError(error: error)
    }
    
    private func trainigCallback(data: [SumTraining]?, error: Responses?) {
        if data != nil && data!.count > 0 {
            if isDataCorrectDay(timestamp: data![0].sessionId) {
                refreshTableViewTraining(sumTrainings: data!)
                
                showProgressBarTraining(isShow: false)
            }
        } else {
            showProgressBarTraining(isShow: false)
        }
        
        initError(error: error)
    }
    
    private func eventDaysCallback(data: [Double]?, error: Responses?) {
        initEventDays(eventDays: data)
        
        initError(error: error)
    }
    
    private func eventCallback(data: [PlanEvent]?, error: Responses?) {
        if data != nil && data!.count > 0 {
            if isDataCorrectDay(timestamp: data![0].event.timestamp) {
                refreshTableViewEvent(planEvents: data!)
                
                showProgressBarEvent(isShow: false)
            }
        } else {
            showProgressBarEvent(isShow: false)
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
        return DateFormatHelper.isSameDay(timeStamp1: timestamp, timeStamp2: self.selectedDate!)
    }
    
    private func initError(error: Responses?) {
        self.error = error
        errorHandling()
    }
    
    
    private func trainingDaysListTrainingDataCallback(error: Responses?, trainingData: [TimeInterval]?) {
        if let trainingDays = trainingData {
            initTrainingDays(trainingDays: trainingDays)
            
            cvCalendarView?.contentController.refreshPresentedMonth()
            getTrainigsList()
        }
        self.error = error
        errorHandling()
    }
    
    private func trainingListTrainingDataCallback(error: Responses?, trainingData: [SumTraining]?) {
        
        self.error = error
        errorHandling()
    }
    
    //MARK: error
    private func errorHandling() {
        if let globalError = self.error {
            errorHandlingWithAlert(viewController: self, error: globalError)
        }
    }
    
    //MARK: init views
    private lazy var tableViewTraining: TrainingTablewView! = {
        let tableViewTraining = TrainingTablewView(view: self.viewTableView, deleteCallback: self.deleteDataCallback)
        
        tableViewTraining.rowClickCallback = { sumTraining, position in
            let viewController = TrainingDetailsPagerViewController()
            viewController.position = position
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        return tableViewTraining
    }()
    
    private lazy var progressBarTraining: UIActivityIndicatorView! = {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: buttonHeight, height: buttonHeight))
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = Colors.colorWhite
        
        return spinner
    }()
    
    private lazy var tableViewEvent: EventTableView! = {
        let tableViewEvent = EventTableView(view: self.viewTableView, deleteCallback: self.deleteDataCallback)
        
        tableViewEvent.rowClickCallback = { planEvent, position in
            startEventDetailsViewController(viewController: self, planEvent: planEvent)
        }
        
        return tableViewEvent
    }()
    
    private lazy var progressBarEvent: UIActivityIndicatorView! = {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: buttonHeight, height: buttonHeight))
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = Colors.colorWhite
        
        return spinner
    }()
    
    private func showProgressBarTraining(isShow: Bool) {
        showProgressBar(progressBar: progressBarTraining, isShow: isShow)
    }
    
    private func showProgressBarEvent(isShow: Bool) {
        showProgressBar(progressBar: progressBarEvent, isShow: isShow)
    }
    
    private func showProgressBar(progressBar: UIActivityIndicatorView, isShow: Bool) {
        if isShow {
            progressBar.startAnimating()
        } else {
            progressBar.stopAnimating()
        }
        
        progressBar.isHidden = !isShow
    }
    
    private lazy var labelMonth: UILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var cvCalendarView: CVCalendarView! = {
        let calendarView = CVCalendarView(frame: CGRect(x: 0, y: 120, width: self.view.frame.width, height: 200))
        calendarView.calendarAppearanceDelegate = self
        calendarView.calendarDelegate = self
        
        calendarView.appearance.dayLabelWeekdayInTextColor = Colors.colorWhite
        calendarView.appearance.dayLabelWeekdaySelectedBackgroundColor = Colors.colorAccent
        calendarView.appearance.dayLabelPresentWeekdaySelectedBackgroundColor = Colors.colorAccent
        
        self.labelMonth.text = DateFormatHelper.getDate(dateFormat: getString("date_format_month"), timeIntervallSince1970: currentTimeMillis())
        //self.refreshMonth(timeStamp: currentTimeMillis())
        self.selectedDate = currentTimeMillis()
        
        return calendarView
    }()
    
    private lazy var calendarMenuView: CVCalendarMenuView! = {
        let calendarMenuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 95, width: self.view.frame.width, height: 20))
        calendarMenuView.dayOfWeekTextColor = Colors.colorWhite
        
        calendarMenuView.menuViewDelegate = self
        
        return calendarMenuView
    }()
    
    //MARK: bar buttons
    private lazy var btnToday: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_event_white_24dp")
        button.target = self
        button.action = #selector(btnTodayClick)
        
        return button
    }()
    
    private lazy var btnAdd: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_add_white")
        button.target = self
        button.action = #selector(addClick)
        
        return button
    }()
    
    //MARK: buttons listeners
    @objc private func btnTodayClick() {
        cvCalendarView?.toggleCurrentDayView()
    }
    
    @objc private func addClick() {
        show(PlanTypeVc(), sender: self)
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
        labelMonth.text = DateFormatHelper.getDate(dateFormat: getString("date_format_month"), timeIntervallSince1970: timeStamp)
        cvCalendarView.contentController.refreshPresentedMonth()
    }
    
    private lazy var segmentedControl: UISegmentedControl! = {
        let control = UISegmentedControl(items: self.segmentItems)
        control.tintColor = Colors.colorAccent
        control.addTarget(self, action: #selector(setSegmentedItem), for: .valueChanged)
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    @objc private func setSegmentedItem(sender: UISegmentedControl) {
        let viewSub: UIView
        switch sender.selectedSegmentIndex {
        case 0:
            viewSub = tableViewEvent
            setMode(mode: CalendarVc.modeEvent)
        default:
            viewSub = tableViewTraining
            setMode(mode: CalendarVc.modeTraining)
        }
        
        viewTableView.removeAllSubviews()
        viewTableView.addSubview(viewSub)
        viewSub.snp.makeConstraints { make in
            make.edges.equalTo(viewTableView)
        }
    }
}
