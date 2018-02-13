//
//  CalculateElementSErgo.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateElementSErgo: CalculateElementS<MeasureCommandErgometer, CommandProcessorErgometer> {

    private var timestampCal: Double = 0
    
    override func run() -> Double {
        if telemetry.getCycleIndex() > 0 {
            
            var timestampCurrent = startCommand.getCalculatedTimeStamp()
            
            if timestampCal == 0 {
                timestampCal = timestampCurrent
            }
            
            let t_1_2 = (timestampCurrent - timestampCal) / 1000
            let v = startCommand.speed
            
            if t_1_2 > 0 && !v.isNaN {
                calculatedValue += (v / converSationMpsKmph) * t_1_2
            }
            
            timestampCal = timestampCurrent
            
            startCommand.distance = calculatedValue
            
        }
        
        return calculatedValue
    }
    
}
