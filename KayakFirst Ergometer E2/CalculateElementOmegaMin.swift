//
//  CalculateElementOmegaMin.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateElementOmegaMin: CalculateElement<Double, MeasureCommandErgometer, CommandProcessorErgometer> {
    
    override func getDataType() -> CalculateEnum {
        return CalculateEnum.OMEGA_MIN
    }
    
    override func run() -> Double {
        if telemetry.getCycleIndex() > 0 {
            let tMax = startCommand.t_max
            if tMax == 0 {
                calculatedValue = 0
            } else {
                calculatedValue = (2 * Double.pi) / (q * tMax)
            }
        }
        return calculatedValue
    }
    
}
