//
//  CalculateElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElement<Result, S: StartCommand<MeasureCommand>> {
    
    //MARK constants
    let oneMinuteInMillisec = 60 * 1000
    let j = 0.02527962
    let q = 1
    let rh = 0.027
    let c = 0.1419262
    let weightBoat: Double = 12
    let weightBodyDefault: Double = 78
    
    //MARK: properties
    let telemetry = Telemetry.sharedInstance
    let userService = UserService.sharedInstance
    let startCommand: S
    
    var calculatedValue: Double = 0
    
    //MARK: moving averages
    private var maF = MovingAverage()
    private var maV = MovingAverage()
    private var maStrokes = MovingAverage()
    private var maT_200 = MovingAverage()
    private var maT_500 = MovingAverage()
    private var maT_1000 = MovingAverage()
    
    private let saveValues = SaveValues.sharedInstance
    
    //MARK: init
    init(startCommand: S) {
        self.startCommand = startCommand
        reset()
    }
    
    //MARK: abstract functions
    func run() -> Result {
        fatalError("Must be implemented")
    }
    
    func getDataType() -> CalculateEnum {
        fatalError("Must be implemented")
    }
    
    private func reset() {
        maF = MovingAverage()
        maV = MovingAverage()
        maStrokes = MovingAverage()
        maStrokes.numAverage = 5
        maT_200 = MovingAverage()
        maT_500 = MovingAverage()
        maT_1000 = MovingAverage()
    }
    
    func getWeight() -> Double {
        var bodyWeight: Double? = weightBodyDefault
        
        let user = userService.getUser()
        
        if let userValue = user {
            bodyWeight = userValue.bodyWeight
        }
        
        return bodyWeight! + weightBoat
    }
    
    func createTrainingObject() -> Training {
        let timeStamp = startCommand.getCalculatedTimeStamp()
        let currentDistance = telemetry.distance
        let userId = userService.getUser()?.id
        let sessionId = telemetry.sessionId
        let trainingType = userService.getTrainingType()
        let trainingEnvironmentType = startCommand.getTrainingEnvironmentType()
        let dataType = getDataType()
        var dataValue = calculatedValue
        
        switch dataType {
        case CalculateEnum.F:
            dataValue = maF.calAverage(newValue: dataValue)
        case CalculateEnum.V:
            dataValue = maV.calAverage(newValue: dataValue)
        case CalculateEnum.STROKES:
            dataValue = maStrokes.calAverage(newValue: dataValue)
        case CalculateEnum.T_200:
            dataValue = maT_200.calAverage(newValue: dataValue)
        case CalculateEnum.T_500:
            dataValue = maT_500.calAverage(newValue: dataValue)
        case CalculateEnum.T_1000:
            dataValue = maT_1000.calAverage(newValue: dataValue)
        default:
            dataValue = calculatedValue
        }
        
        let training = Training(
            timeStamp: timeStamp,
            currentDistance: currentDistance,
            userId: userId,
            sessionId: sessionId,
            trainingType: trainingType,
            trainingEnvironmentType: trainingEnvironmentType,
            dataType: dataType.rawValue,
            dataValue: dataValue)
        
        saveValues.addValue(training: training)
        
        return training
    }
    
    
}
