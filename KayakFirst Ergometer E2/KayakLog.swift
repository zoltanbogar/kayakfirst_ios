//
//  KayakLog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class KayakLog {
    
    private static let logNeeded = true
    
    private static let logDateFormat = "HH.mm.ss.SSS"
    
    class func log (_ key: String, _ message: String) {
        if logNeeded {
            let date = DateFormatHelper.getDate(dateFormat: logDateFormat, timeIntervallSince1970: Date().timeIntervalSince1970)
            print("\(date) - \(key): \(message)")
        }
    }
    
}
