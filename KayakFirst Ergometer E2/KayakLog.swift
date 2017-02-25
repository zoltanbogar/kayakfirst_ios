//
//  KayakLog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

private let logNeeded = true

private let logDateFormat = "HH.mm.ss.SSS"

func log (_ key: String, _ message: Any) {
    if logNeeded {
        let date = DateFormatHelper.getDate(dateFormat: logDateFormat, timeIntervallSince1970: currentTimeMillis())
        print("\(date) - \(key): \(message)")
    }
}
