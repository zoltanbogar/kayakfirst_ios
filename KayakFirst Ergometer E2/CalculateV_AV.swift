//
//  CalculateElementV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateV_AV<M: MeasureCommand>: CalculateElementAvg<M> {
    
    override func getActValue() -> Double {
        return telemetry.speed
    }
    
    override func getAvValue() -> Double {
        return telemetry.speed_av
    }
}
