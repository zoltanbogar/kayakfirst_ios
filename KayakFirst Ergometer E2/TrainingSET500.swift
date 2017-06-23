//
//  TrainingSET500.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingSET500: TrainingSumElementMinimumTime {
    
    override func getTitleMetric() -> String {
        return getString("training_sum_t_200_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("training_sum_t_200_imperial")
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricPace()
    }
    
    override func getTrainingList() -> [Training] {
        return trainingDataService.detailsTrainingList![position!].t500List
    }
}
