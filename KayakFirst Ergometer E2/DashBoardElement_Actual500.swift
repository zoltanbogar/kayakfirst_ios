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
    
    override internal func getTitle() -> String {
        return getString("dashboard_outdoor_title_actual_500")
    }
    
    override func getTitleOneLine() -> String {
        return getString("dashboard_title_actual_500")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Actual500.tagInt
    }
    
}
