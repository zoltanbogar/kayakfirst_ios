//
//  DateFormatHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

//MARK: time enum
enum TimeEnum: String {
    case timeFormatTwo = "%02d:%02d"
    case timeFormatThree = "%02d:%02d:%02d"
}

func currentTimeMillis() -> TimeInterval {
    return NSDate().timeIntervalSince1970 * 1000
}

class DateFormatHelper {
    
    //MARK: Properties
    var format: TimeEnum?

    //MARK: Functions
    func getTime(millisec: Double) -> String? {
        var timeText: String? = nil
        
        let hours = Int(millisec / (1000 * 60 * 60))
        let minutes = Int((millisec / (1000 * 60)).truncatingRemainder(dividingBy: 60))
        let seconds = Int((millisec / 1000).truncatingRemainder(dividingBy: 60))
        if getFormatValues() == 3 {
            timeText = String(format: (format?.rawValue)!, hours, minutes, seconds)
        } else  {
           timeText = String(format: (format?.rawValue)!, minutes, seconds)
        }
        return timeText
    }
    
    private func getFormatValues() -> Int {
        var formatValues = 0
        if let formatString = format?.rawValue {
            for c in formatString.characters {
                if c == "%" {
                    formatValues += 1
                }
            }
        }
        return formatValues
    }
    
    class func getZeroHour(timeStamp: Double) -> Double {
        return Calendar(identifier: .gregorian).startOfDay(for: Date(timeIntervalSince1970: timeStamp)).timeIntervalSince1970
    }
    
    class func get23Hour(timeStamp: Double) -> Double {
        return getZeroHour(timeStamp: timeStamp) + 86340
    }
    
    class func isSameDay(timeStamp1: TimeInterval, timeStamp2: TimeInterval) -> Bool {
        let format = "yyyy.MM.dd"
        return getDate(dateFormat: format, timeIntervallSince1970: timeStamp1) == getDate(dateFormat: format, timeIntervallSince1970: timeStamp2)
    }
    
    class func getDate(dateFormat: String, timeIntervallSince1970: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date(timeIntervalSince1970: (timeIntervallSince1970 / 1000)))
    }
    
    class func getMilliSeconds(date: Date) -> TimeInterval {
        return date.timeIntervalSince1970 * 1000
    }
}
