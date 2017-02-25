//
//  DashBoardElement_Actual1000.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Actual1000: DashBoardelementTime {
    
    static let tagInt = 3
    
    override func getStringFormatter() -> String {
        return TimeEnum.timeFormatTwo.rawValue
    }
    
    override func getValue() -> Double {
        return telemetry.t_1000
    }
    
    override internal func getTitle() -> String {
        return getString("dashboard_outdoor_title_actual_1000")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Actual1000.tagInt
    }
}
