//
//  TrainingSET200Av.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingSET200Av: TrainingSumElementAvgTime {
    
    override func getTrainingType() -> String {
        return CalculateEnum.T_200_AV.rawValue
    }
    
    override func getTitle() -> String {
        return getString("training_sum_t_200")
    }
    
    override func getUnit() -> String {
        return ""
    }
    
    override func getTrainingList() -> [Training] {
        return createTrainingList!.t200List[position!]
    }
}
