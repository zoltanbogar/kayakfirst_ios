//
//  TrainingSEForce.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingSEForce: TrainingSumelementMaximum {
    
    override func getFormatter() -> String {
        return "%.0f"
    }
    
    override func getTitle() -> String {
        return getString("training_sum_pull_force")
    }
    
    override func getUnit() -> String {
        return getString("unit_force")
    }
    
    override func getTrainingList() -> [Training] {
        return createTrainingList!.fList[position!]
    }
    
}
