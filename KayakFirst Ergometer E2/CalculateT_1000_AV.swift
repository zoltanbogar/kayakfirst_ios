//
//  CalculateT_1000_AV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateT_1000_AV: CalculateElementAvg {
    
    override func getAvgType() -> CalculateEnum {
        return CalculateEnum.T_1000_AV
    }
    
    override func getActValue() -> Double {
        return telemetry.t_1000
    }
    
    override func getAvValue() -> Double {
        return telemetry.t_1000_av
    }
    
}
