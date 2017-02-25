//
//  DashBoardElement_avStrokes.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_AvStrokes: DashBoardElementBase {
    
    static let tagInt = 9
    
    override func getStringFormatter() -> String {
        return "%.0f"
    }
    
    override func getValue() -> Double {
        return telemetry.storkes_av
    }
    
    override func getTitle() -> String {
        return getString("dashboard_outdoor_title_av_strokes")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_AvStrokes.tagInt
    }
}
