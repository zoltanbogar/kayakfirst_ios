//
//  DashBoardElement_PullForce.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_PullForce: DashBoardElementBase {
    
    static let tagInt = 13
    
    override func getStringFormatter() -> String {
        return "%.0f"
    }
    
    override func getValue() -> Double {
        return UnitHelper.getForceValue(metricValue: telemetry.force)
    }
    
    override func getTitleMetric() -> String {
        return getString("dashboard_outdoor_title_pull_force_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("dashboard_outdoor_title_pull_force_imperial")
    }
    
    override func getTitleOneLineMetric() -> String {
        return getString("dashboard_title_pull_force_metric")
    }
    
    override func getTitleOneLineImperial() -> String {
        return getString("dashboard_title_pull_force_imperial")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_PullForce.tagInt
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricWeight()
    }
}
