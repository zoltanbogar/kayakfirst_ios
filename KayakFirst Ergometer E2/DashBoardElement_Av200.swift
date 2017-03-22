//
//  DashBoardElement_Av200.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Av200: DashBoardelementTime {
    
    static let tagInt = 4
    
    override func getStringFormatter() -> String {
        return TimeEnum.timeFormatTwo.rawValue
    }
    
    override func getValue() -> Double {
        return telemetry.t_200_av
    }
    
    override internal func getTitle() -> String {
        return getString("dashboard_outdoor_title_av_200")
    }
    
    override func getTitleOneLine() -> String {
        return getString("dashboard_title_av_200")
    }
    
    override func getTagInt() -> Int {
        return DashBoardElement_Av200.tagInt
    }
}
