//
//  DashBoardElement_Actual500.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class DashBoardElement_Actual500: DashBoardelementTime {
    
    static let tagInt = 2
    
    override func getStringFormatter() -> String {
        return TimeEnum.timeFormatTwo.rawValue
    }
    
    override func getValue() -> Double {
        return telemetry.t_500
    }
    
    override func getTitleMetric() -> String {
        return getString("dashboard_outdoor_title_actual_500_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("dashboard_outdoor_title_actual_500_imperial")
    }
    
    override func getTitleOneLineMetric() -> String {
        return getString("dashboard_title_actual_500_metric")
    }
    
    override func getTitleOneLineImperial() -> String {
        return getString("dashboard_title_actual_500_imperial")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Actual500.tagInt
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricPace()
    }
    
}
