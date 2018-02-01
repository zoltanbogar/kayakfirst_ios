//
//  SystemInfoDto.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 01..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class SystemInfoDto {
    
    class func createSystemInfoDtosParameter(systemInfos: [SystemInfo]?) -> (Array<[String:Any]>)? {
        if let systemInfos = systemInfos {
            var parameters = Array<[String:Any]>()
            
            for systemInfo in systemInfos {
                let systemInfoDto = SystemInfoDto(systemInfo: systemInfo)
                parameters.append(systemInfoDto.getParameters())
            }
            return parameters
        } else {
            return nil
        }
    }
    
    private let versionCode: Int
    private let versionName: String
    private let timestamp: Double
    private let locale: String
    private let brand: String
    private let model: String
    private let osVersion: String
    private let userName: String
    
    private init(systemInfo: SystemInfo) {
        self.versionCode = systemInfo.versionCode
        self.versionName = systemInfo.versionName
        self.timestamp = systemInfo.timestamp
        self.locale = systemInfo.locale
        self.brand = systemInfo.brand
        self.model = systemInfo.model
        self.osVersion = systemInfo.osVersion
        self.userName = systemInfo.userName
    }
    
    func getParameters() -> [String : Any] {
        return [
            "versionCode": versionCode,
            "versionName": versionName,
            "timestamp": timestamp,
            "locale": locale,
            "brand": brand,
            "model": model,
            "osVersion": osVersion,
            "userName": userName
        ]
    }
    
}
