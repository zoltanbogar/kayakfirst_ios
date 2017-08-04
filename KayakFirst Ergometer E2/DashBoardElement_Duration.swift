//
//  DashBoardElement_Duration.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Duration: DashBoardelementTime {
    
    static let tagInt = 12
    
    override func getStringFormatter() -> String {
        return TimeEnum.timeFormatTwo.rawValue
    }

    override func getValue() -> Double {
        return telemetry.duration
    }
    
    override func getTitleMetric() -> String {
        return getString("dashboard_outdoor_title_duration")
    }
    
    override func getTitleImperial() -> String {
        return getString("dashboard_outdoor_title_duration")
    }
    
    override func getTitleOneLineMetric() -> String {
        return getString("dashboard_title_duration")
    }
    
    override func getTitleOneLineImperial() -> String {
        return getString("dashboard_title_duration")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Duration.tagInt
    }
    
    override func isMetric() -> Bool {
        return true
    }
}
