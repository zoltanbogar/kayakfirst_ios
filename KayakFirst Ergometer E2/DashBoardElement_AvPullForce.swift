//
//  DashBoardElement_AvPullForce.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_AvPullForce: DashBoardElementBase {
    
    static let tagInt = 7
    
    override func getStringFormatter() -> String {
        return "%.0f"
    }
    
    override func getValue() -> Double {
        return telemetry.force_av
    }
    
    override func getTitle() -> String {
        return getString("dashboard_outdoor_title_av_pull_force")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_AvPullForce.tagInt
    }
}
