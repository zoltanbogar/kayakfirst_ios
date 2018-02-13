//
//  CalculateElementOmegaMax.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateElementOmegaMax: CalculateElement<MeasureCommandErgometer, CommandProcessorErgometer> {
    
    override func run() -> Double {
        if telemetry.getCycleIndex() > 0 {
            calculatedValue = (2 * Double.pi) / (q * startCommand.t_min)
        }
        
        return calculatedValue
    }
    
}
