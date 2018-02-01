//
//  FeedbackDto.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 01..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class FeedbackDto {
    
    private let message: String
    private let systemInfos: [SystemInfo]?
    private let logs: [LogObject]?
    
    init(message: String, systemInfos: [SystemInfo]?, logs: [LogObject]?) {
        self.message = message
        self.systemInfos = systemInfos
        self.logs = logs
    }
    
    func getParameters() -> [String : Any] {
        let systemInfoParameters = SystemInfoDto.createSystemInfoDtosParameter(systemInfos: systemInfos)
        let logParameters = LogDto.createLogDtosParameter(logObjects: logs)
        
        return [
            "message": message,
            "systemInfos": systemInfoParameters ?? "",
            "logs": logParameters ?? ""
        ]
    }
    
}
