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
    
    //MARK: views
    private var stackView: UIStackView?
    private let viewTableView = UIView()
    private let viewCalendar = UIView()
    private let trainingTableViewHeader = TrainingTableViewHeader()
    
    //MARK: trainigData
    private var trainingDays: [TimeInterval]?
    
    //MARK: service
    private let trainingDataService = TrainingDataService.sharedInstance
    
    //MARK: properties
    private var selectedDate: TimeInterval?
    private var error: Responses?
    private var shouldRefresh = true
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainingDataService.trainingDataCallback = trainingListTrainingDataCallback
        trainingDataService.trainingDaysCallback = trainingDaysListTrainingDataCallback
        trainingDataService.progressListener = progressListener
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldRefresh {
            getTrainingDays()
        } else {
            shouldRefresh = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        refreshCalendarDesign()
    }
    
    internal override func initView() {
        stackView = UIStackView()
        stackView?.distribution = .fillEqually
        stackView?.spacing = margin
        
        viewCalendar.removeAllSubviews()
        viewCalendar.addSubview(cvCalendarView)
        viewCalendar.addSubview(labelMonth)
        viewCalendar.addSubview(calendarMenuView)
        labelMonth.snp.makeConstraints { (make) in
            make.width.equalTo(viewCalendar)
            make.top.equalTo(viewCalendar).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
        }
        
        viewTableView.removeAllSubviews()
        viewTableView.addSubview(trainingTableViewHeader)
        trainingTableViewHeader.snp.makeConstraints { (make) in
            make.top.equalTo(viewTableView)
            make.left.equalTo(viewTableView)
            make.right.equalTo(viewTableView)
        }
        let viewDivider = UIView()
        viewDivider.backgroundColor = Colors.colorDashBoardDivider
        viewTableView.addSubview(viewDivider)
        viewDivider.snp.makeConstraints { (make) in
            make.top.equalTo(trainingTableViewHeader.snp.bottom)
            make.left.equalTo(viewTableView)
            make.right.equalTo(viewTableView)
            let height = 2 * dashboardDividerWidth
            make.height.equalTo(height)
        }
        //TODO: dividers error on left
        viewTableView.addSubview(tableViewTraining)
        tableViewTraining.snp.makeConstraints { (make) in
            make.top.equalTo(viewDivider)
            make.left.equalTo(viewTableView)
            make.right.equalTo(viewTableView)
            make.bottom.equalTo(viewTableView)
        }
        
        stackView?.addArrangedSubview(viewCalendar)
        stackView?.addArrangedSubview(viewTableView)
        
        contentView.addSubview(stackView!)
        stackView?.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        viewTableView.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.center.equalTo(viewTableView)
        }
    }
    
    override func handlePortraitLayout(size: CGSize) {
        stackView?.axis = .vertical
        
        let width: CGFloat = size.width
        let height: CGFloat = 200
        
        cvCalendarView.frame = CGRect(x: 0, y: 80, width: width, height: height)
        calendarMenuView.frame = CGRect(x: 0, y: 55, width: width, height: 20)
        
        refreshCalendarDesign()
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        stackView?.axis = .horizontal
        
        let width: CGFloat = size.width / 2
        let height: CGFloat = 200
        
        log("CALENDAR", "width: \(width)")
        
        cvCalendarView.frame = CGRect(x: 0, y: 50, width: width, height: height)
        calendarMenuView.frame = CGRect(x: 0, y: 25, width: width, height: 20)
        
        refreshCalendarDesign()
    }
    
    private func refreshCalendarDesign() {
        cvCalendarView.commitCalendarViewUpdate()
        calendarMenuView?.commitMenuViewUpdate()
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems([btnToday], animated: true)
        showLogoOnLeft()
    }
    
    //MARK: call service
    func getTrainingDays() {
        trainingDataService.getTrainingDays()
    }
    
    private func initTrainingDays(trainingDays: [TimeInterval]?) {
        if let trainingDaysValue = trainingDays {
            for trainingDay in trainingDaysValue {
                if self.trainingDays == nil {
                    self.trainingDays = [TimeInterval]()
                }
                
                if !self.trainingDays!.contains(trainingDay) {
                    self.trainingDays!.append(trainingDay)
                }
            }
        }
    }
    
    private func getTrainigsList() {
        var hasData = false
        if let trainingDaysList = trainingDays {
            for trainingDay in trainingDaysList {
                hasData = DateFormatHelper.isSameDay(timeStamp1: trainingDay, timeStamp2: selectedDate!)
                
                if hasData {
                    break
                }
            }
        }
        
        if hasData {
            let fromDate = DateFormatHelper.getZeroHour(timeStamp: selectedDate!)
            let toDate = DateFormatHelper.get23Hour(timeStamp: selectedDate!)
            trainingDataService.getTrainingList(sessionIdFrom: fromDate, sessionIdTo: toDate)
        } else {
            refreshTableView(sumTrainings: nil)
        }
        errorHandling()
    }
    
    private func refreshTableView(sumTrainings: [SumTraining]?) {
        trainingTableViewHeader.isHidden = sumTrainings == nil
        tableViewTraining?.dataList = sumTrainings
    }
    
    //MARK: callbacks
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
        if let sumTrainings = trainingData {
            if sumTrainings.count > 0 {
                if DateFormatHelper.isSameDay(timeStamp1: sumTrainings[0].sessionId!, timeStamp2: self.selectedDate!) {
                    refreshTableView(sumTrainings: sumTrainings)
                }
            }
        }
        self.error = error
        errorHandling()
    }
    
    //MARK: error
    private func errorHandling() {
        if let globalError = self.error {
            showProgressBar(isShow: false)
            AppService.errorHandlingWithAlert(viewController: self, error: globalError)
        }
    }
    
    //MARK: init views
    private lazy var tableViewTraining: TrainingTablewView! = {
        let tableViewTraining = TrainingTablewView(view: self.viewTableView)
        
        tableViewTraining.rowClickCallback = { sumTraining, position in
            self.trainingDataService.detailsTrainingList = tableViewTraining.dataList

            let viewController = TrainingDetailsPagerViewController()
            viewController.position = position
            self.navigationController?.pushViewController(viewController, animated: true)
            
            self.shouldRefresh = false
        }
        
        return tableViewTraining
    }()
    
    private lazy var progressBar: UIActivityIndicatorView! = {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: buttonHeight, height: buttonHeight))
        spinner.activityIndicatorViewStyle = .whiteLarge
        
        return spinner
    }()
    
    private func progressListener(onProgress: Bool) {
        showProgressBar(isShow: onProgress)
    }
    
    //TODO: refactor this
    private func showProgressBar(isShow: Bool) {
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
        
        //TODO: why is that?
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
    
    private lazy var btnToday: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_event_white_24dp")
        button.target = self
        button.action = #selector(btnTodayClick)
        
        return button
    }()
    
    @objc private func btnTodayClick() {
        cvCalendarView?.toggleCurrentDayView()
    }
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .monday
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        if let trainingDayList = trainingDays {
            if trainingDayList.contains(dayView.date.getTimeMillis()) {
                return true
            }
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
        
        if selectedDate != date.getTimeMillis() {
            selectedDate = date.getTimeMillis()
            getTrainigsList()
        }
    }
    
    //TODO: bug: if calendar swipes a little the training data will be empty for this day
    private func refreshMonth(timeStamp: TimeInterval) {
        labelMonth.text = DateFormatHelper.getDate(dateFormat: getString("date_format_month"), timeIntervallSince1970: timeStamp)
        cvCalendarView.contentController.refreshPresentedMonth()
    }
}
