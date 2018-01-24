//
//  SystemInfo.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 23..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

struct SystemInfo: Equatable {
    
    static func ==(lhs: SystemInfo, rhs: SystemInfo) -> Bool {
        return lhs.versionCode == rhs.versionCode &&
        lhs.locale == rhs.locale &&
        lhs.userName == rhs.userName
    }
    
    let versionCode: Int
    let versionName: String
    let timestamp: Double
    let locale: String
    let brand: String
    let model: String
    let osVersion: String
    let userName: String
    let userId: Int64
}
