//
//  CVDate+.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CVCalendar

extension CVDate {
    
    func getTimeMillis() -> TimeInterval {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        let calendar = Calendar.current
        return DateFormatHelper.getMilliSeconds(date: calendar.date(from: dateComponents)!)
    }
    
}
