//
//  DashBoardElement_Strokes.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Strokes: DashBoardElementBase {
    
    static let tagInt = 14
    
    override func getStringFormatter() -> String {
        return "%.0f"
    }
    
    override func getValue() -> Double {
        return telemetry.strokes
    }
    
    override func getTitle() -> String {
        return getString("dashboard_outdoor_title_stroke_min")
    }
    
    override func getTitleOneLine() -> String {
        return getString("dashboard_title_stroke_min")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Strokes.tagInt
    }
}
