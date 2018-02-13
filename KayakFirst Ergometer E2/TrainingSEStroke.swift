//
//  TrainingSEStroke.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingSEStroke: TrainingSumelementMaximum {
    
    override func getFormatter() -> String {
        return "%.0f"
    }
    
    override func getTitleMetric() -> String {
        return getString("training_sum_stroke")
    }
    
    override func getTitleImperial() -> String {
        return getString("training_sum_stroke")
    }
    
    override func isMetric() -> Bool {
        return true
    }
    
}
