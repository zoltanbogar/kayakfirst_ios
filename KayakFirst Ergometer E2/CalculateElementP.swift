//
//  CalculateElementP.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateElementP: CalculateElement<Double, MeasureCommandErgometer, StartCommandErgometer> {
    
    override func getDataType() -> CalculateEnum {
        return CalculateEnum.P
    }
    
    override func run() -> Double {
        if telemetry.cycleIndex > 0 {
            let w_min = (j * pow(startCommand.omegaMin, 2)) / 2
            let w_max = (j * pow(startCommand.omegaMax, 2)) / 2
            let w = w_max - w_min
            let th = startCommand.t_h
            
            if w > 0 && !th.isNaN && th > 0 {
                calculatedValue = w / th
            }
        }
        return calculatedValue
    }
    
}
