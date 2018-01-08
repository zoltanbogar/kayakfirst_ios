//
//  CalculateElementFErgo.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateElementFErgo: CalculateElementF<MeasureCommandErgometer, CommandProcessorErgometer> {
    
    //MARK: constants
    private let maxForce: Double = 20000
    
    override func run() -> Training {
        if telemetry.getCycleIndex() > 0 {
            let omegaMin = startCommand.omegaMin
            let omegaMax = startCommand.omegaMax
            
            let th = startCommand.t_h
            
            if omegaMax > omegaMin && th > 0 {
                let force = (j * (omegaMax - omegaMin)) / (th * rh)
                
                if force < maxForce {
                    calculatedValue = force
                }
            }
        }
        return createTrainingObject()
    }
    
}
