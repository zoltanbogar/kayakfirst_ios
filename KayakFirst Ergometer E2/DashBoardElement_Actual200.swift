//
//  DashBoardElement_Actual200.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Actual200: DashBoardelementTime {
    
    static let tagInt = 1
    
    override func getStringFormatter() -> String {
        return TimeEnum.timeFormatTwo.rawValue
    }
    
    override func getValue() -> Double {
        return UnitHelper.getPaceValue(pace: 200, metricValue: telemetry.t_200)
    }
    
    override func getTitleMetric() -> String {
        return getString("dashboard_outdoor_title_actual_200_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("dashboard_outdoor_title_actual_200_imperial")
    }
    
    override func getTitleOneLineMetric() -> String {
         return getString("dashboard_title_actual_200_metric")
    }
    
    override func getTitleOneLineImperial() -> String {
         return getString("dashboard_title_actual_200_imperial")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Actual200.tagInt
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricPace()
    }
}
