//
//  CalculateF_AV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateF_AV: CalculateElementAvg {
    
    override func getAvgType() -> CalculateEnum {
        return CalculateEnum.F_AV
    }
    
    override func getActValue() -> Double {
        return telemetry.force
    }
    
    override func getAvValue() -> Double {
        return telemetry.force_av
    }
    
}
