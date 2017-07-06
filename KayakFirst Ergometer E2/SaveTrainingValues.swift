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
    private let trainingDbLoader = TrainingDbLoader.sharedInstance
    private let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
    private let userManager = UserManager.sharedInstance
    
    private var localeSessionId: Double = 0
    
    //MARK: init
    static let sharedInstance: SaveTrainingValues = SaveTrainingValues()
    private init() {
        //private constructor
    }
    
    func addValue(training: Training) {
        if CalculateEnum.savingTypes.contains(CalculateEnum(rawValue: training.dataType)!) && userManager.getUser() != nil {
            trainingDbLoader.addData(data: training)
        }
    }
    
    func saveTrainingAvgData(telemetryObject: TelemetryObject, telemetryAvgObject: TelemetryAvgObject) {
        if userManager.getUser() != nil {
            trainingAvgDbLoader.addData(data: telemetryAvgObject.f_av)
            trainingAvgDbLoader.addData(data: telemetryAvgObject.v_av)
            trainingAvgDbLoader.addData(data: createTrainingAvgObject(training: telemetryObject.s_sum))
            trainingAvgDbLoader.addData(data: telemetryAvgObject.strokes_av)
            trainingAvgDbLoader.addData(data: telemetryAvgObject.t_200_av)
            trainingAvgDbLoader.addData(data: telemetryAvgObject.t_500_av)
            trainingAvgDbLoader.addData(data: telemetryAvgObject.t_1000_av)
        }
    }
    
    private func createTrainingAvgObject(training: Training) -> TrainingAvg {
        return TrainingAvg(
            userId: training.userId!,
            sessionId: training.sessionId,
            avgType: training.dataType,
            avgValue: training.dataValue)
    }
}
