//
//  DashBoardElement_Av500.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Av500: DashBoardelementTime {
    
    static let tagInt = 5
    
    override func getStringFormatter() -> String {
        return TimeEnum.timeFormatTwo.rawValue
    }
    
    override func getValue() -> Double {
        return UnitHelper.getPaceValue(pace: 500, metricValue: telemetry.t_500_av)
    }
    
    override func getTitleMetric() -> String {
        return getString("dashboard_outdoor_title_av_500_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("dashboard_outdoor_title_av_500_imperial")
    }
    
    override func getTitleOneLineMetric() -> String {
        return getString("dashboard_title_av_500_metric")
    }
    
    override func getTitleOneLineImperial() -> String {
        return getString("dashboard_title_av_500_imperial")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Av500.tagInt
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricPace()
    }
}
