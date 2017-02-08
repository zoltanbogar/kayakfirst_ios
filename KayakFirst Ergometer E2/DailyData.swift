//
//  DailyData.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DailyData {
    
    var sumTrainingList: [SumTraining]?
    var date: TimeInterval
    
    init(date: TimeInterval) {
        self.date = date
    }
    
    func add(sumTrainings: [SumTraining]) {
        if sumTrainingList == nil {
            sumTrainingList = [SumTraining]()
        }
        
        for s in sumTrainings {
            if !sumTrainingList!.contains(s) {
                sumTrainingList!.append(s)
            }
        }
        
        sumTrainingList = sumTrainingList?.sorted(by: {
            $0.startTime! < $1.startTime!
        })
    }
    
}
