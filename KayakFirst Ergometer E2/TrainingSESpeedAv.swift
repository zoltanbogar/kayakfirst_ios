//
//  TrainingSESpeedAv.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingSESpeedAv: TrainingSumElementAverage {
    
    override func getTrainingType() -> String {
        return CalculateEnum.V_AV.rawValue
    }
    
    override func getFormatter() -> String {
        return "%.1f"
    }
    
    override func getTitle() -> String {
        return getString("training_sum_speed")
    }
    
    override func getUnit() -> String {
        return getString("unit_speed")
    }
    
    override func getTrainingList() -> [Training] {
        return trainingDataService.detailsTrainingList![position!].vList
    }
}
