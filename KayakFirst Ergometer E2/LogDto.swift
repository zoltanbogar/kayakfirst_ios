//
//  LogDto.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 01..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class LogDto {
    
    class func createLogDtosParameter(logObjects: [LogObject]?) -> (Array<[String:Any]>)? {
        if let logObjects = logObjects {
            var parameters = Array<[String:Any]>()
            
            for logObject in logObjects {
                let logDto = LogDto(logObject: logObject)
                parameters.append(logDto.getParameters())
            }
            return parameters
        } else {
            return nil
        }
    }
    
    private let log: String
    private let timestamp: Double
    private let systemInfoTimestamp: Double
    
    private init(logObject: LogObject) {
        self.log = logObject.log
        self.timestamp = logObject.timestamp
        self.systemInfoTimestamp = logObject.systemInfoTimestamp
    }
    
    func getParameters() -> [String : Any] {
        return [
            "log": log,
            "timestamp": timestamp,
            "systemInfoTimestamp": systemInfoTimestamp
        ]
    }
    
}
