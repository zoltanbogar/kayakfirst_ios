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
    
    override func getTitleMetric() -> String {
        return getString("training_sum_speed_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("training_sum_speed_imperial")
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricDistance()
    }
    
    override func getTrainingList() -> [Training] {
        return sumTraining.vList
    }
    
    override func calculate() -> Double {
        return UnitHelper.getSpeedValue(metricValue: sumTraining.avgV)
    }
}
