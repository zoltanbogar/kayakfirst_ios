//
//  CalculateElementStrokes.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateElementStrokes: CalculateElementStroke<MeasureCommandErgometer, StartCommandErgometer> {
    
    private var cycleIndex: Int64 = 0
    private var timestamp: Double = 0
    
    override func run() -> Training {
        if telemetry.cycleIndex > 0 {
            let diffCycleIndex = telemetry.cycleIndex - cycleIndex
            cycleIndex = telemetry.cycleIndex
            var timeDiff: Double = 0
            
            if timestamp != 0 {
                timeDiff = startCommand.getCalculatedTimeStamp() - timestamp
            }
            
            timestamp = startCommand.getCalculatedTimeStamp()
            if timeDiff != 0 {
                calculatedValue = Double(diffCycleIndex) / timeDiff / oneMinuteInMillisec
            }
        }
        
        return createTrainingObject()
    }
    
}
