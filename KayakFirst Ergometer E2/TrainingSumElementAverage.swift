//
//  TrainingSumElementAverage.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingSumElementAverage: BaseTrainingSumElement {
    
    override func getFormattedValue(value: Double) -> String {
        return String(format: getFormatter(), value)
    }
    
    override func calculate() -> Double {
        if trainingList != nil && trainingList!.count > 0 {
            let avgHash = TrainingDataService.sharedInstance.getTrainigAvg(
                hash: TrainingAvg.getAvgHash(
                    userId: UserService.sharedInstance.getUser()!.id,
                    avgType: getTrainingType(),
                    sessionId: trainingList![0].sessionId))
            
            if let averageHash = avgHash {
                return averageHash
            } else {
                var sumValue: Double = 0
                for trainig in trainingList! {
                    sumValue = sumValue + trainig.dataValue
                }
                
                let averageValue = sumValue / Double(trainingList!.count)
                
                return averageValue
            }
        }
        return 0
    }
    
    //MARK: abstract functions
    func getFormatter() -> String {
        fatalError("Must be implemented")
    }
    
    func getTrainingType() -> String {
        fatalError("Must be implemented")
    }
    
}
