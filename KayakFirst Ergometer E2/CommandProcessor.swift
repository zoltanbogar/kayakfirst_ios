//
//  StartCommand.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CommandProcessor<E: MeasureCommand> {
    
    //MARK: properties
    let telemetry = Telemetry.sharedInstance
    
    private var f_avElement: CalculateF_AV<E>?
    private var t200Av: CalculateT_200_AV<E>?
    private var t200Element: CalculateElementT_200<E>?
    
    var force: Double = 0
    var speed: Double = 0
    var distance: Double = 0
    var strokes: Double = 0
    
    var forceAv: Double = 0
    var speedAv: Double = 0
    var strokesAv: Double = 0
    
    private var maF = MovingAverage()
    private var maV = MovingAverage()
    private var maStrokes = MovingAverage()
    
    func calculate(measureCommands: [E]) -> TrainingNew {
        return calculateValues(measureCommands: measureCommands)
    }
    
    func calculateAvg() -> TrainingAvgNew {
        return createTrainingAvg()
    }
    
    func reset() {
        f_avElement = CalculateF_AV(startCommand: self)
        t200Av = CalculateT_200_AV(startCommand: self)
        t200Element = CalculateElementT_200(startCommand: self)
        
        force = 0
        speed = 0
        distance = 0
        strokes = 0
        
        forceAv = 0
        speedAv = 0
        strokesAv = 0
        
        maF = MovingAverage()
        maV = MovingAverage()
        maStrokes = MovingAverage(numAverage: 5)
    }
    
    //MARK: abstract functions
    func getTrainingEnvironmentType() -> TrainingEnvironmentType {
        fatalError("Must be implemented")
    }
    
    func calculateValues(measureCommands: [E]) -> TrainingNew {
        fatalError("Must be implemented")
    }
    
    func createTraining() -> TrainingNew {
        return KayakFirst_Ergometer_E2.createTraining(
            timestamp: getCalculatedTimeStamp(),
            force: maF.calAverage(newValue: force),
            speed: maV.calAverage(newValue: speed),
            distance: distance,
            strokes: maStrokes.calAverage(newValue: strokes),
            t200: t200Element!.run())
    }
    
    func createTrainingAvg() -> TrainingAvgNew {
        return KayakFirst_Ergometer_E2.createTrainingAvg(
            force: f_avElement!.run(),
            speed: speedAv,
            strokes: strokesAv,
            t200: t200Av!.run())
    }
    
    //MARK: timestamp
    func getCalculatedTimeStamp() -> Double {
        return telemetry.getAbsoluteTimestamp()
    }
    
    func getDoubleFromCommand(measureCommand: MeasureCommand) -> Double {
        return CommandParser.getDouble(stringValue: measureCommand.getValue()!)
    }
}
