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
    
    //MARK: constants
    static let timeFormat = "kk:mm"
    static let dateFormat = getString("date_format")
    static let dateTimeFormat = getString("date_time_format")
    static let minSecFormat = "mm:ss"
    
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
    
    class func getZeroHour(timeStamp: TimeInterval) -> TimeInterval {
        let date = Date(timeIntervalSince1970: timeStamp/1000)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        return getMilliSeconds(date: calendar.date(from: dateComponents)!)
    }
    
    class func getTimestampFromDatePicker(datePicker: UIDatePicker) -> TimeInterval {
        return DateFormatHelper.get23Hour(timeStamp: DateFormatHelper.getMilliSeconds(date: datePicker.date))
    }
    
    class func get23Hour(timeStamp: TimeInterval) -> TimeInterval {
        return getZeroHour(timeStamp: timeStamp) + 86399000
    }
    
    class func getTimestampByDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> TimeInterval {
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        return getMilliSeconds(date: calendar.date(from: dateComponents)!)
    }
    
    class func isSameDay(timeStamp1: TimeInterval, timeStamp2: TimeInterval) -> Bool {
        let format = "yyyy.MM.dd"
        return getDate(dateFormat: format, timeIntervallSince1970: timeStamp1) == getDate(dateFormat: format, timeIntervallSince1970: timeStamp2)
    }
    
    class func getDate(dateFormat: String, timeIntervallSince1970: TimeInterval?) -> String {
        if let timeStamp = timeIntervallSince1970 {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            return formatter.string(from: Date(timeIntervalSince1970: (timeStamp / 1000)))
        }
        return ""
    }
    
    class func getMilliSeconds(date: Date) -> TimeInterval {
        return date.timeIntervalSince1970 * 1000
    }
}
