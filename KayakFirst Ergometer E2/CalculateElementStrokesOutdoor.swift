//
//  CalculateElementStrokesOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementStrokesOutdoor: CalculateElementStroke<StartCommandOutdoor> {
    
    private var cycleIndex: Int64 = 0
    private var timeStamp: Double = 0
    
    override func run() -> Training {
        let diffCycleIndex = telemetry.cycleIndex - cycleIndex
        cycleIndex = telemetry.cycleIndex
        
        var timeDiff: Double = 0
        
        if timeStamp != 0 {
            timeDiff = startCommand.getCalculatedTimeStamp() - timeStamp
        }
        
        timeStamp = startCommand.getCalculatedTimeStamp()
        
        if timeDiff != 0 {
            calculatedValue = (Double(diffCycleIndex) / (timeDiff / Double(oneMinuteInMillisec)))
        }
        
        return createTrainingObject()
    }
    
}
