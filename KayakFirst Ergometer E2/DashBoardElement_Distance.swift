//
//  DashBoardElement_Distance.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Distance: DashBoardElementBase {
    
    static let tagInt = 11
    
    override func getStringFormatter() -> String {
        return "%.0f"
    }
    
    override func getValue() -> Double {
        return telemetry.distance
    }
    
    override func getTitleMetric() -> String {
        return getString("dashboard_outdoor_title_distance_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("dashboard_outdoor_title_distance_imperial")
    }
    
    override func getTitleOneLineMetric() -> String {
        return getString("dashboard_title_distance_metric")
    }
    
    override func getTitleOneLineImperial() -> String {
        return getString("dashboard_title_distance_imperial")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Distance.tagInt
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricDistance()
    }
}
