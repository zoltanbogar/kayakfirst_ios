//
//  TrainingSET1000.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingSET1000: TrainingSumElementMinimumTime {
    
    override func getTitle() -> String {
        return getString("training_sum_t_1000")
    }
    
    override func getUnit() -> String {
        return ""
    }
    
    override func getTrainingList() -> [Training] {
        return createTrainingList!.t1000List[position!]
    }
}
