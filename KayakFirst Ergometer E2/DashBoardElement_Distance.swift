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
    
    override func getTitle() -> String {
        return getString("dashboard_title_distance")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Distance.tagInt
    }
}
