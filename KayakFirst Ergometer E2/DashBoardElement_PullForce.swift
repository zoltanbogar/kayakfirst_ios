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
        return telemetry.force
    }
    
    override func getTitle() -> String {
        return getString("dashboard_title_pull_force")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_PullForce.tagInt
    }
}
