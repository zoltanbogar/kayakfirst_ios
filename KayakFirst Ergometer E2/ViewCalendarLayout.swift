//
//  ViewCalendarLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 14..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CVCalendar

class ViewCalendarLayout: BaseLayout {
    
     private let calendarHeight: CGFloat = 190
    
    override func setView() {
        contentView.addSubview(cvCalendarView)
        contentView.addSubview(calendarMenuView)
        contentView.addSubview(labelMonth)
        
        labelMonth.snp.makeConstraints { (make) in
            make.width.equalTo(contentView)
            make.bottom.equalTo(calendarMenuView.snp.top).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
    }
    
    override func handlePortraitLayout(size: CGSize) {
        super.handlePortraitLayout(size: size)
        
        let width: CGFloat = size.width
        let height: CGFloat = calendarHeight
        
        cvCalendarView.frame = CGRect(x: 0, y: 100, width: width, height: height)
        calendarMenuView.frame = CGRect(x: 0, y: 75, width: width, height: 20)
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        super.handleLandscapeLayout(size: size)
        
        let width: CGFloat = size.width / 2
        let height: CGFloat = calendarHeight
        
        cvCalendarView.frame = CGRect(x: 0, y: 90, width: width, height: height)
        calendarMenuView.frame = CGRect(x: 0, y: 75, width: width, height: 20)
    }
    
    func designCalendarView() {
        cvCalendarView.appearance.dayLabelWeekdayInTextColor = Colors.colorWhite
        cvCalendarView.appearance.dayLabelWeekdaySelectedBackgroundColor = Colors.colorAccent
        cvCalendarView.appearance.dayLabelPresentWeekdaySelectedBackgroundColor = Colors.colorAccent
    }
    
    lazy var labelMonth: UILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var cvCalendarView: CVCalendarView! = {
        let calendarView = CVCalendarView(frame: CGRect(x: 0, y: 120, width: self.contentView.frame.width, height: 200))
        
        self.labelMonth.text = DateFormatHelper.getDate(dateFormat: getString("date_format_month"), timeIntervallSince1970: currentTimeMillis())
        
        return calendarView
    }()
    
    lazy var calendarMenuView: CVCalendarMenuView! = {
        let calendarMenuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 95, width: self.contentView.frame.width, height: 20))
        calendarMenuView.dayOfWeekTextColor = Colors.colorWhite
        
        return calendarMenuView
    }()
    
}
