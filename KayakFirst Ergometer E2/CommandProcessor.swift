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
    
    private var t200Element: CalculateElementT_200<E>?
    private var t500Element: CalculateElementT_500<E>?
    private var t1000Element: CalculateElementT_1000<E>?
    private var f_avElement: CalculateF_AV<E>?
    private var t200_avElement: CalculateT_200_AV<E>?
    private var t500_avElement: CalculateT_500_AV<E>?
    private var t1000_avElement: CalculateT_1000_AV<E>?
    
    var strokes: Training = Training()
    var f: Training = Training()
    var v: Training = Training()
    var s: Training = Training()
    
    var strokesAv: TrainingAvg?
    var vAv: TrainingAvg?
    
    var v_av: Double = 0
    var distanceSum: Double = 0
    
    func calculate(measureCommands: [E]) -> TelemetryObject {
        return calculateValues(measureCommands: measureCommands)
    }
    
    func calculateAvg() -> TelemetryAvgObject {
        return createTelemetryAvgObject()
    }
    
    func reset() {
        t200Element = CalculateElementT_200(startCommand: self)
        t500Element = CalculateElementT_500(startCommand: self)
        t1000Element = CalculateElementT_1000(startCommand: self)
        
        f_avElement = CalculateF_AV(startCommand: self)
        t200_avElement = CalculateT_200_AV(startCommand: self)
        t500_avElement = CalculateT_500_AV(startCommand: self)
        t1000_avElement = CalculateT_1000_AV(startCommand: self)
        
        strokes = Training()
        f = Training()
        v = Training()
        s = Training()
        
        v_av = 0
        distanceSum = 0
    }
    
    //MARK: abstract functions
    func getTrainingEnvironmentType() -> TrainingEnvironmentType {
        fatalError("Must be implemented")
    }
    
    func calculateValues(measureCommands: [E]) -> TelemetryObject {
        fatalError("Must be implemented")
    }
    
    //MARK: create telemetry objects
    func createTelemetryOjbect() -> TelemetryObject {
        return TelemetryObject(
            f: f,
            v: v,
            s_sum: s,
            strokes: strokes,
            t200: t200Element!.run(),
            t500: t500Element!.run(),
            t1000: t1000Element!.run())
    }
    
    func createTelemetryAvgObject() -> TelemetryAvgObject {
        return TelemetryAvgObject(
            f_av: f_avElement!.run(),
            v_av: vAv!,
            strokes_av: strokesAv!,
            t_200_av: t200_avElement!.run(),
            t_500_av: t500_avElement!.run(),
            t_1000_av: t1000_avElement!.run())
    }
    
    //MARK: timestamp
    func getCalculatedTimeStamp() -> Double {
        return telemetry.getAbsoluteTimestamp()
    }
    
    func getDoubleFromCommand(measureCommand: MeasureCommand) -> Double {
        return CommandParser.getDouble(stringValue: measureCommand.getValue()!)
    }
}
