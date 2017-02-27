//
//  CalculateElementV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateV_AV: CalculateElementAvg {
    
    override func getAvgType() -> CalculateEnum {
        return CalculateEnum.V_AV
    }
    
    override func getActValue() -> Double {
        return telemetry.speed
    }
    
    override func getAvValue() -> Double {
        return telemetry.speed_av
    }
    
}
