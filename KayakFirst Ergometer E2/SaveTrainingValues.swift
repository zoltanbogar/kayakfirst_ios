//
//  SaveValues.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class SaveTrainingValues {
    
    //MARK: properties
    private let trainingDbLoader = TrainingNewDbLoader.sharedInstance
    private let trainingAvgDbLoader = TrainingAvgNewDbLoader.sharedInstance
    private let sumTrainingDbLoader = SumTrainingDbLoader.sharedInstance
    private let userManager = UserManager.sharedInstance
    
    //MARK: init
    static let sharedInstance: SaveTrainingValues = SaveTrainingValues()
    private init() {
        //private constructor
    }
    
    func saveTrainingData(training: TrainingNew, trainingAvg: TrainingAvgNew, sumTrainig: SumTrainingNew) {
        if userManager.getUser() != nil {
            trainingDbLoader.addData(data: training)
            trainingAvgDbLoader.addData(data: trainingAvg)
            sumTrainingDbLoader.addData(data: sumTrainig)
        }
    }
}
