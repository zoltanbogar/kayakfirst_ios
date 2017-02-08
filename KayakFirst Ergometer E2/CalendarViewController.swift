//
//  CalendarViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {
    
    //MARK: views
    private var calendarView: CVCalendarView?
    private var calendarMenuView: CVCalendarMenuView?
    private var tableViewTraining: TrainingTablewView?
    private let stackView = UIStackView()
    private let viewCalendar = UIView()
    private let viewTableView = UIView()
    
    //MARK: trainigData
    private var trainingDays: [TimeInterval]?
    
    //MARK: service
    private let trainingService = TrainingService.sharedInstance
    
    //MARK: properties
    private var selectedDate: TimeInterval?
    private var dailyDataList: [DailyData]?
    private var error: Responses?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView();
        getTrainingDays()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView?.commitCalendarViewUpdate()
        calendarMenuView?.commitMenuViewUpdate()
    }
    
    private func initView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        stackView.addArrangedSubview(viewCalendar)
        stackView.addArrangedSubview(viewTableView)
        
        viewCalendar.addSubview(initCalendarView())
        viewCalendar.addSubview(labelMonth)
        viewCalendar.addSubview(initCalendarMenuView())
        viewTableView.addSubview(initTableViewTraining())
        tableViewTraining!.snp.makeConstraints { make in
            make.edges.equalTo(viewTableView)
        }
        
        viewTableView.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.center.equalTo(viewTableView)
        }
    }
    
    //MARK: call service
    private func getTrainingDays() {
        TrainingService.sharedInstance.getTrainingDays(trainingDataCallback: trainingDaysCallback)
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
            if getDailyData() {
                refreshTableView()
            } else {
                let fromDate = DateFormatHelper.getZeroHour(timeStamp: selectedDate!)
                let toDate = DateFormatHelper.get23Hour(timeStamp: selectedDate!)
                trainingService.getTrainingList(trainingDataCallback: trainingListCallback, timeStampFrom: fromDate, timeStampTo: toDate)
                showProgressBar(isShow: true)
            }
        } else {
            tableViewTraining?.dataList = nil
            showProgressBar(isShow: false)
        }
        errorHandling()
    }
    
    private func refreshTableView() {
        if let dailyData = dailyDataList {
            var dataAvailable = false
            
            for d in dailyData {
                if DateFormatHelper.isSameDay(timeStamp1: d.date, timeStamp2: selectedDate!) {
                    let sumTrainings = d.sumTrainingList
                    
                    dataAvailable = sumTrainings != nil
                    tableViewTraining?.dataList = sumTrainings
                }
            }
            showProgressBar(isShow: !dataAvailable)
        }
    }
    
    private func getDailyData() -> Bool {
        if dailyDataList == nil {
            dailyDataList = [DailyData]()
        }
        
        for d in dailyDataList! {
            if DateFormatHelper.isSameDay(timeStamp1: d.date, timeStamp2: selectedDate!) {
                return true
            }
        }
        dailyDataList!.append(DailyData(date: selectedDate!))
        return false
    }
    
    private func addDailyData(trainingList: [Training]?) {
        if trainingList != nil && trainingList!.count > 0 {
            for d in dailyDataList! {
                if DateFormatHelper.isSameDay(timeStamp1: d.date, timeStamp2: trainingList![0].sessionId) {
                    let sumTrainingList = SumTraining.createSumTrainingList(trainings: trainingList!)
                    d.add(sumTrainings: sumTrainingList!)
                }
            }
        }
    }
    
    //MARK: callbacks
    private func trainingDaysCallback(error: Responses?, trainingData: [TimeInterval]?) {
        if let trainingDays = trainingData {
            self.trainingDays = trainingDays
            calendarView?.contentController.refreshPresentedMonth()
            getTrainigsList()
        }
        self.error = error
        errorHandling()
    }
    
    private func trainingListCallback(error: Responses?, trainingData: [Training]?) {
        if let trainings = trainingData {
            addDailyData(trainingList: trainings)
            refreshTableView()
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
    private func initTableViewTraining() -> TrainingTablewView {
        tableViewTraining = TrainingTablewView(view: self.viewTableView, frame: CGRect.zero)
        
        tableViewTraining?.rowClickCallback = { sumTraining, position in
            let viewController = TrainingDetailsPagerViewController()
            viewController.position = position
            viewController.sumTrainingList = self.tableViewTraining!.dataList
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        return tableViewTraining!
    }
    
    private lazy var progressBar: UIActivityIndicatorView! = {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: buttonHeight, height: buttonHeight))
        spinner.activityIndicatorViewStyle = .whiteLarge
        
        return spinner
    }()
    
    private func showProgressBar(isShow: Bool) {
        if isShow {
            progressBar.startAnimating()
            tableViewTraining?.dataList = nil
        } else {
            progressBar.stopAnimating()
        }
        
        progressBar.isHidden = !isShow
    }
    
    private lazy var labelMonth: UILabel! = {
        let label = AppUILabel(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 20))
        label.textAlignment = .center
        
        return label
    }()
    
    private func initCalendarView() -> CVCalendarView {
        calendarView = CVCalendarView(frame: CGRect(x: 0, y: 120, width: view.frame.width, height: 200))
        calendarView?.calendarAppearanceDelegate = self
        calendarView?.calendarDelegate = self
        
        calendarView?.appearance.dayLabelWeekdayInTextColor = Colors.colorWhite
        calendarView?.appearance.dayLabelWeekdaySelectedBackgroundColor = Colors.colorAccent
        calendarView?.appearance.dayLabelPresentWeekdaySelectedBackgroundColor = Colors.colorAccent
        
        refreshMonth(timeStamp: currentTimeMillis())
        selectedDate = currentTimeMillis()
        
        return calendarView!
    }
    
    private func initCalendarMenuView() -> CVCalendarMenuView {
        calendarMenuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 95, width: view.frame.width, height: 20))
        calendarMenuView?.dayOfWeekTextColor = Colors.colorWhite
        
        calendarMenuView?.menuViewDelegate = self
        
        return calendarMenuView!
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
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [Colors.colorAccent]
    }
    
    func dayLabelWeekdayInTextColor() -> UIColor {
        return Colors.colorWhite
    }
    
    //TODO
    /*func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }*/
    
    func presentedDateUpdated(_ date: CVDate) {
        refreshMonth(timeStamp: date.getTimeMillis())
        
        if selectedDate != date.getTimeMillis() {
            selectedDate = date.getTimeMillis()
            getTrainigsList()
        }
    }
    
    private func refreshMonth(timeStamp: TimeInterval) {
        labelMonth.text = DateFormatHelper.getDate(dateFormat: getString("date_format_month"), timeIntervallSince1970: timeStamp)
        calendarView?.contentController.refreshPresentedMonth()
    }
    
    
}
