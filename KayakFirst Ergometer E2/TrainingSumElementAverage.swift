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
    
    //MARK: abstract functions
    func getFormatter() -> String {
        fatalError("Must be implemented")
    }
    
    func getTrainingType() -> String {
        fatalError("Must be implemented")
    }
    
}
