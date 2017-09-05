//
//  CalculateElementVErgo.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateElementVErgo: CalculateElementV<MeasureCommandErgometer, StartCommandErgometer> {
    
    override func run() -> Training {
        if telemetry.getCycleIndex() > 0 {
            let p = startCommand.p
            let mass = pow(getWeight(), 0.666667)
            
            if !p.isNaN && p > 0 {
                var testCalculatedValue = pow((p / (c * mass)), 0.33333)
                testCalculatedValue = converSationMpsKmph * testCalculatedValue
                
                if testCalculatedValue < maxSpeedKmph {
                    calculatedValue = testCalculatedValue
                }
            }
        }
        
        return createTrainingObject()
    }
    
}
