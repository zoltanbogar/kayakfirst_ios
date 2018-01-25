//
//  LogEventHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 24..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class LogEventHelper {
    
    class func logEvent(event: String) {
        let logObject = LogObject.createLogObject(log: event)
        LogObjectDbLoader.sharedInstance.addData(data: logObject)
    }
    
    //TODO: add real implementation
    class func createLogFile() {
        let systemInfoList = SystemInfoHelper.getSystemInfos()
        
        if let systemInfoList = systemInfoList {
            for systemInfo in systemInfoList {
                
                let logObjects = LogObjectDbLoader.sharedInstance.getLogObjects(systemInfoTimestamp: systemInfo.timestamp)
                
                if let logObjects = logObjects {
                    writeToFile(systemInfo: systemInfo, logObjects: logObjects)
                }
            }
        }
    }
    
    private class func writeToFile(systemInfo: SystemInfo, logObjects: [LogObject]) {
        
        var completLog = getSystemInfoString(systemInfo: systemInfo)
        completLog += "\n"
        completLog += "*******************"
        completLog += "\n"
        
        for logObject in logObjects {
            let timestamp = getFormattedTimestamp(timestamp: logObject.timestamp)
            let value = logObject.log
            let logLine = timestamp + " " + value
            
            completLog += logLine
            completLog += "\n"
        }
        
        log("LOG_TEST", "\(completLog)")
    }
    
    private class func getSystemInfoString(systemInfo: SystemInfo) -> String {
        let versionCode = "versionCode: \(systemInfo.versionCode)"
        let versionName = "versionName: \(systemInfo.versionName)"
        let timestamp = "timestamp: \(getFormattedTimestamp(timestamp: systemInfo.timestamp))"
        let locale = "locale: \(systemInfo.locale)"
        let brand = "brand: \(systemInfo.brand)"
        let model = "model: \(systemInfo.model)"
        let osVersion = "osVersion: \(systemInfo.osVersion)"
        let userName = "userName: \(systemInfo.userName)"
        let userId = "userId: \(systemInfo.userId)"
        
        let systemInfoString = versionCode + "\n" + versionName + "\n" + timestamp + "\n" + locale + "\n" + brand + "\n" + model + "\n" + osVersion + "\n" + userName + "\n" + userId
        
        return systemInfoString
    }
    
    private class func getFormattedTimestamp(timestamp: Double) -> String {
        return DateFormatHelper.getDate(dateFormat: DateFormatHelper.dateTimeFormat, timeIntervallSince1970: timestamp)
    }
    
}
