//
//  TrainingSEForceAv.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 03. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingSEForceAv: TrainingSumElementAverage {
    
    override func getTrainingType() -> String {
        return CalculateEnum.F_AV.rawValue
    }
    
    override func getFormatter() -> String {
        return "%.0f"
    }
    
    override func getTitleMetric() -> String {
        return getString("training_sum_pull_force_metric")
    }
    
    override func getTitleImperial() -> String {
        return getString("training_sum_pull_force_imperial")
    }
    
    override func isMetric() -> Bool {
        return UnitHelper.isMetricWeight()
    }
    
    override func calculate() -> Double {
        return UnitHelper.getForceValue(metricValue: sumData)
    }
}
