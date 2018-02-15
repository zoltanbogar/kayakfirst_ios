//
//  CalendarView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 14..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CVCalendar

protocol CalendarDelegate {
    func onDateSelected(timestamp: Double)
}

class CalendarView: CustomUi<ViewCalendarLayout>, CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {
    
    var selectedDate: TimeInterval = currentTimeMillis()
    var delegate: CalendarDelegate?
    
    var timestamps: [TimeInterval]? {
        didSet {
            contentLayout!.cvCalendarView?.contentController.refreshPresentedMonth()
        }
    }
    
    override func initView() {
        super.initView()
        
        contentLayout!.cvCalendarView.calendarAppearanceDelegate = self
        contentLayout!.cvCalendarView.calendarDelegate = self
        contentLayout!.calendarMenuView.menuViewDelegate = self
    }
    
    override func getContentLayout(contentView: UIView) -> ViewCalendarLayout {
        return ViewCalendarLayout(contentView: contentView)
    }
    
    func handlePortraitLayout(size: CGSize) {
        contentLayout!.handlePortraitLayout(size: size)
    }
    
    func handleLandscapeLayout(size: CGSize) {
        contentLayout!.handleLandscapeLayout(size: size)
    }
    
    func designCalendarView() {
        contentLayout!.cvCalendarView.commitCalendarViewUpdate()
        contentLayout!.calendarMenuView?.commitMenuViewUpdate()
        contentLayout!.designCalendarView()
    }
    
    func setToday() {
        contentLayout!.cvCalendarView?.toggleCurrentDayView()
    }
    
    private func refreshMonth(timeStamp: TimeInterval) {
        contentLayout!.labelMonth.text = DateFormatHelper.getDate(dateFormat: getString("date_format_month"), timeIntervallSince1970: timeStamp)
        contentLayout!.cvCalendarView.contentController.refreshPresentedMonth()
    }
    
    //MARK: delegate
    func presentedDateUpdated(_ date: CVDate) {
        refreshMonth(timeStamp: date.getTimeMillis())
        
        if selectedDate != date.getTimeMillis() {
            selectedDate = date.getTimeMillis()
            
            delegate?.onDateSelected(timestamp: selectedDate)
        }
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
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .monday
    }
    
    //TODO: add HashMap with correct eventDays
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        if let timestamps = timestamps {
            if timestamps.contains(dayView.date.getTimeMillis()) {
                return true
            }
        }
        return false
    }
    
}
