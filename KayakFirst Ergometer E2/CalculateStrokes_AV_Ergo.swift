//
//  CalculateStrokes_AV_Ergo.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateStrokes_AV_Ergo: CalculateStrokes_AV<MeasureCommandErgometer> {
    
    override func calculate() -> Double {
        let durationTest = telemetry.duration
        
        let cycleIndexTest: Double = Double(telemetry.getCycleIndex())
        
        if durationTest != 0 {
            calculatedValue = cycleIndexTest / (durationTest / oneMinuteInMillisec)
        }
        
        return calculatedValue
    }
    
}
