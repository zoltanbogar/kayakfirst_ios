//
//  DashBoardElement_Av1000.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Av1000: DashBoardelementTime {
    
    static let tagInt = 6
    
    override func getStringFormatter() -> String {
        return TimeEnum.timeFormatTwo.rawValue
    }
    
    override func getValue() -> Double {
        return UnitHelper.getPaceValue(pace: 1000, metricValue: telemetry.t_1000_av)
    }
    
    override func getTitleMetric() -> String {
        return getString("dashboard_outdoor_title_av_1000_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("dashboard_outdoor_title_av_1000_imperial")
    }
    
    override func getTitleOneLineMetric() -> String {
        return getString("dashboard_title_av_1000_metric")
    }
    
    override func getTitleOneLineImperial() -> String {
        return getString("dashboard_title_av_1000_imperial")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Av1000.tagInt
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricPace()
    }
}
