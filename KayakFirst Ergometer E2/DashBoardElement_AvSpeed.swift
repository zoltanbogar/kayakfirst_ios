//
//  DashBoardElement_AvSpeed.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_AvSpeed: DashBoardElementBase {
    
    static let tagInt = 8
    
    override func getStringFormatter() -> String {
        return "%.1f"
    }
    
    override func getValue() -> Double {
        return telemetry.speed_av
    }
    
    override func getTitle() -> String {
        return getString("dashboard_outdoor_title_av_speed")
    }
    
    override func getTitleOneLine() -> String {
        return getString("dashboard_title_av_speed")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_AvSpeed.tagInt
    }
}
