//
//  TrainingSET1000Av.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingSET1000Av: TrainingSumElementAvgTime {
    
    override func getTrainingType() -> String {
        return CalculateEnum.T_1000_AV.rawValue
    }
    
    override func getTitleMetric() -> String {
        return getString("training_sum_t_1000_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("training_sum_t_1000_imperial")
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricPace()
    }
    
    override func getTrainingList() -> [Training] {
        return trainingDataService.detailsTrainingList![position!].t1000List
    }
}
