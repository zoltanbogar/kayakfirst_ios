//
//  TrainingSumElementMinimumTime.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingSumElementMinimumTime: BaseTrainingSumElement {
    
    override func getFormattedValue(value: Double) -> String {
        let dateFormatHelper = DateFormatHelper()
        dateFormatHelper.format = TimeEnum.timeFormatTwo
        return dateFormatHelper.getTime(millisec: value)!
    }
    
    //TODO: can be deleted?
    override func calculate() -> Double {
        var minValue: Double = 0
        
        /*if trainingList!.count > 0 {
            for training in trainingList! {
                minValue = training.dataValue
                
                if minValue > 0 {
                    break
                }
            }
            
            for training in trainingList! {
                if training.dataValue < minValue && training.dataValue != 0 {
                    minValue = training.dataValue
                }
            }
        }*/
        return minValue
    }
    
}
