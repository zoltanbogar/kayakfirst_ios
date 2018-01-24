//
//  LogObject.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 24..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class LogObject {
    
    class func createLogObject(log: String) -> LogObject {
        let systemInfo = AppLog.getSystemInfo()
        
        let user = UserManager.sharedInstance.getUser()
        let userId = user != nil ? user!.id : 0
        
        return LogObject(
            log: log,
            timestamp: currentTimeMillis(),
            systemInfoTimestamp: systemInfo!.timestamp,
            userId: userId)
    }
    
    let log: String
    let timestamp: Double
    let systemInfoTimestamp: Double
    let userId: Int64
    
    init(row: Row, logExpression: Expression<String>, timestampExpression: Expression<Double>, systemInfoTimestampExpression: Expression<Double>, userIdExpression: Expression<Int64>) {
        self.log = row[logExpression]
        self.timestamp = row[timestampExpression]
        self.systemInfoTimestamp = row[systemInfoTimestampExpression]
        self.userId = row[userIdExpression]
    }
    
    private init(log: String, timestamp: Double, systemInfoTimestamp: Double, userId: Int64) {
        self.log = log
        self.timestamp = timestamp
        self.systemInfoTimestamp = systemInfoTimestamp
        self.userId = userId
    }
    
}
