//
//  CreateTrainingList.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CreateTrainingList {
    
    private var sumTrainingList: [SumTraining]
    
    var t200List = [[Training]]()
    var t500List = [[Training]]()
    var t1000List = [[Training]]()
    var strokesList = [[Training]]()
    var fList = [[Training]]()
    var vList = [[Training]]()
    var distanceList = [[Training]]()
    
    init(sumTrainings: [SumTraining]) {
        self.sumTrainingList = sumTrainings
        
        createTrainingList()
    }
    
    private func createTrainingList() {
        for sumTraining in sumTrainingList {
            var t200s = [Training]()
            var t500s = [Training]()
            var t1000s = [Training]()
            var strokess = [Training]()
            var fs = [Training]()
            var vs = [Training]()
            var ds = [Training]()
            
            for training in sumTraining.trainingList! {
                if CalculateEnum.T_200.rawValue == training.dataType {
                    t200s.append(training)
                } else if CalculateEnum.T_500.rawValue == training.dataType {
                    t500s.append(training)
                } else if CalculateEnum.T_1000.rawValue == training.dataType {
                    t1000s.append(training)
                } else if CalculateEnum.STROKES.rawValue == training.dataType {
                    strokess.append(training)
                } else if CalculateEnum.F.rawValue == training.dataType {
                    fs.append(training)
                } else if CalculateEnum.V.rawValue == training.dataType {
                   vs.append(training)
                } else if CalculateEnum.S.rawValue == training.dataType {
                    ds.append(training)
                }
            }
            t200List.append(t200s)
            t500List.append(t500s)
            t1000List.append(t1000s)
            strokesList.append(strokess)
            fList.append(fs)
            vList.append(vs)
            distanceList.append(ds)
        }
    }
    
}
