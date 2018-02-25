//
//  TimestampObject.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 25..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TimestampObject {
    
    var timestampsServer: [Double]?
    var timestampsLocale: [Double]?
    
    func addServerId(timestampServer: Double) {
        if timestampsServer == nil {
            timestampsServer = [Double]()
        }
        timestampsServer?.append(timestampServer)
    }
    
    func addLocaleId(timestampLocale: Double) {
        if timestampsLocale == nil {
            timestampsLocale = [Double]()
        }
        timestampsLocale?.append(timestampLocale)
    }
    
}
