//
//  CalculateElementStrokesErgo.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateElementStrokesErgo: CalculateElementStroke<MeasureCommandErgometer, CommandProcessorErgometer> {
    
    private var cycleIndex: Int64 = 0
    private var timestamp: Double = 0
    
    private var maSpm = MovingAverage(numAverage: 5)
    
    override func run() -> Double {
        if telemetry.getCycleIndex() > 0 {
            let diffCycleIndex = telemetry.getCycleIndex() - cycleIndex
            
            if timestamp == 0 {
                timestamp = telemetry.lastCycleIndexTime
            }
            
            let timeDiff: Double = telemetry.lastCycleIndexTime - timestamp
            
            if timeDiff > 0 {
                cycleIndex = telemetry.getCycleIndex()
                
                timestamp = telemetry.lastCycleIndexTime
                
                let spm = Double(diffCycleIndex) / (timeDiff / oneMinuteInMillisec)
                
                if spm <= AppSensorManager.maxSpm {
                    calculatedValue = maSpm.calAverage(newValue: spm)
                }
            }
        }
        
        return calculatedValue
    }
    
}
