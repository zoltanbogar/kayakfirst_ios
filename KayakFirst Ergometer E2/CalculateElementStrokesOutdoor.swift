//
//  CalculateElementStrokesOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementStrokesOutdoor: CalculateElementStroke<StartCommandOutdoor> {
    
    override func run() -> Training {
        let currentSpeed = telemetry.speed
        
        if currentSpeed < Double(minSpeedKmh) {
            calculatedValue = 0
        } else {
            calculatedValue = startCommand.strokesValue
        }
        
        return createTrainingObject()
    }
}
