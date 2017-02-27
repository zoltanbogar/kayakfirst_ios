//
//  SaveValues.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class SaveValues {
    
    //MARK: properties
    private let trainingDbLoader = TrainingDbLoader()
    private let trainingAvgDbLoader = TrainingAvgDbLoader()
    private let trainingDaysDbLoader = TrainingDaysDbLoader()
    private let userService = UserService.sharedInstance
    private let telemetry = Telemetry.sharedInstance
    
    private var localeSessionId: Double = 0
    
    //MARK: init
    static let sharedInstance: SaveValues = SaveValues()
    private init() {
        //private constructor
    }
    
    func addValue(training: Training) {
        if CalculateEnum.savingTypes.contains(CalculateEnum(rawValue: training.dataType)!) && userService.getUser() != nil {
            trainingDbLoader.addData(data: training)
            
            saveSessionId()
        }
    }
    
    func saveTrainingAvgData(telemetryObject: TelemetryObject, telemetryAvgObject: TelemetryAvgObject) {
        trainingAvgDbLoader.addData(data: telemetryAvgObject.f_av)
        trainingAvgDbLoader.addData(data: telemetryAvgObject.v_av)
        trainingAvgDbLoader.addData(data: createTrainingAvgObject(training: telemetryObject.s_sum))
        trainingAvgDbLoader.addData(data: telemetryAvgObject.strokes_av)
        trainingAvgDbLoader.addData(data: telemetryAvgObject.t_200_av)
        trainingAvgDbLoader.addData(data: telemetryAvgObject.t_500_av)
        trainingAvgDbLoader.addData(data: telemetryAvgObject.t_1000_av)
    }
    
    private func createTrainingAvgObject(training: Training) -> TrainingAvg {
        return TrainingAvg(
            userId: training.userId!,
            sessionId: training.sessionId,
            avgType: training.dataType,
            avgValue: training.dataValue)
    }
    
    private func saveSessionId() {
        let sessionId = telemetry.sessionId
        
        if localeSessionId != sessionId {
            trainingDaysDbLoader.addData(data: sessionId)
            localeSessionId = sessionId
        }
    }
    
}
