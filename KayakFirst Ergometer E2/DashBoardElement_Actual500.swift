//
//  DashBoardElement_Actual500.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashBoardElement_Actual500: DashBoardelementTime {
    
    override func getStringFormatter() -> TimeEnum {
        return TimeEnum.timeFormatTwo
    }
    
    //TODO
    override func getValue() -> Double {
        return 0.0
    }
    
    override internal func getTitle() -> String {
        return try! getString("dashboard_title_actual_500")
    }
    
}
