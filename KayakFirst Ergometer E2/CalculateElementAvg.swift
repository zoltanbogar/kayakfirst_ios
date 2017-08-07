//
//  CalculateElementAvg.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementAvg<M: MeasureCommand>: CalculateElement<TrainingAvg, M,  StartCommand<M>> {
    
    //MARK: abstract functions
    internal func getAvgType() -> CalculateEnum {
        fatalError("Must be implemented")
    }
    
    internal func getActValue() -> Double {
        fatalError("Must be implemented")
    }
    
    internal func getAvValue() -> Double {
        fatalError("Must be implemented")
    }
    
    override func run() -> TrainingAvg {
        return createTrainingAvg()
    }
    
    internal func calculate() -> Double {
        let index: Double = Double(telemetry.averageIndex)
        
        if index > 0 && !getAvValue().isNaN && !getAvValue().isNaN {
            calculatedValue = ((getAvValue() * (index - 1)) + getActValue()) / index
        }
        
        return calculatedValue
    }
    
    private func createTrainingAvg() -> TrainingAvg {
        let userId = userManager.getUser()?.id
        let sessionId = telemetry.sessionId
        
        return TrainingAvg(
            userId: userId,
            sessionId: sessionId,
            avgType: getAvgType().rawValue,
            avgValue: calculate())
    }
}
