//
//  DateFormatHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DateFormatHelper {
    
    class func getDate(dateFormat: String, timeIntervallSince1970: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date(timeIntervalSince1970: timeIntervallSince1970))
    }
    
}
