//
//  TrainingSEStrokesAv.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingSEStrokesAv: TrainingSumElementAverage {
    
    override func getTrainingType() -> String {
        return CalculateEnum.STROKES_AV.rawValue
    }
    
    override func getFormatter() -> String {
        return "%.0f"
    }
    
    override func getTitle() -> String {
        return getString("training_sum_stroke")
    }
    
    override func getUnit() -> String {
        return ""
    }
    
    override func getTrainingList() -> [Training] {
        return createTrainingList!.strokesList[position!]
    }
}
