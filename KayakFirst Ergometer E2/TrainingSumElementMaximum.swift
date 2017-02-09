//
//  TrainingSumElementMaximum.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingSumelementMaximum: BaseTrainingSumElement {
    
    override func getFormattedValue(value: Double) -> String {
        return String(format: getFormatter(), value)
    }
    
    override func calculate() -> Double {
        var maxValue: Double = 0
        
        for training in trainingList! {
            if training.dataValue > maxValue {
                maxValue = training.dataValue
            }
        }
        
        return maxValue
    }
    
    //MARK: abstract function
    func getFormatter() -> String {
        fatalError("Must be implemented")
    }
    
}
