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
    
    //MARK: trainigData
    private var trainingDays: [TimeInterval]?
    
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
        view.addSubview(initCalendarMenuView())
        view.addSubview(initCalendarView())
        view.addSubview(labelMonth)
    }
    
    private func getTrainingDays() {
        TrainingService.sharedInstance.getTrainingDays(trainingDataCallback: trainingDaysCallback)
    }
    
    private func trainingDaysCallback(error: Responses?, trainingData: [TimeInterval]?) {
        if let trainingDays = trainingData {
            self.trainingDays = trainingDays
            calendarView?.contentController.refreshPresentedMonth()
        } else if let userError = error {
            AppService.errorHandlingWithAlert(viewController: self, error: userError)
        }
    }
    
    //MARK: inint views
    private lazy var labelMonth: UILabel! = {
        let label = AppUILabel(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 20))
        label.textAlignment = .center
        
        return label
    }()
    
    private func initCalendarView() -> CVCalendarView {
        calendarView = CVCalendarView(frame: CGRect(x: 0, y: 120, width: view.frame.width, height: view.frame.height/2))
        calendarView?.calendarAppearanceDelegate = self
        calendarView?.calendarDelegate = self
        
        calendarView?.appearance.dayLabelWeekdayInTextColor = Colors.colorWhite
        calendarView?.appearance.dayLabelWeekdaySelectedBackgroundColor = Colors.colorAccent
        calendarView?.appearance.dayLabelPresentWeekdaySelectedBackgroundColor = Colors.colorAccent
        
        refreshMonth(timeStamp: currentTimeMillis())
        
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
    }
    
    private func refreshMonth(timeStamp: TimeInterval) {
        labelMonth.text = DateFormatHelper.getDate(dateFormat: getString("date_format_month"), timeIntervallSince1970: timeStamp)
        calendarView?.contentController.refreshPresentedMonth()
    }
}
