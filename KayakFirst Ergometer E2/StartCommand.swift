//
//  StartCommand.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class StartCommand<E: MeasureCommand> {
    
    //MARK: properties
    let telemetry = Telemetry.sharedInstance
    let pauseDiff = PauseDiff.sharedInstance
    
    private var t200Element: CalculateElementT_200?
    private var t500Element: CalculateElementT_500?
    private var t1000Element: CalculateElementT_1000?
    private var f_avElement: CalculateF_AV?
    private var v_avElement: CalculateV_AV?
    private var t200_avElement: CalculateT_200_AV?
    private var t500_avElement: CalculateT_500_AV?
    private var t1000_avElement: CalculateT_1000_AV?
    
    var strokes: Training = Training()
    var f: Training = Training()
    var v: Training = Training()
    var s: Training = Training()
    
    var strokesAv: TrainingAvg?
    
    var v_av: Double = 0
    
    
    func calculate(measureCommands: [E]) -> TelemetryObject {
        return calculateValues(measureCommands: measureCommands)
    }
    
    func calculateAvg() -> TelemetryAvgObject {
        return createTelemetryAvgObject()
    }
    
    func reset() {
        t200Element = CalculateElementT_200(startCommand: getSelfStartCommand())
        t500Element = CalculateElementT_500(startCommand: getSelfStartCommand())
        t1000Element = CalculateElementT_1000(startCommand: getSelfStartCommand())
        
        f_avElement = CalculateF_AV(startCommand: getSelfStartCommand())
        v_avElement = CalculateV_AV(startCommand: getSelfStartCommand())
        t200_avElement = CalculateT_200_AV(startCommand: getSelfStartCommand())
        t500_avElement = CalculateT_500_AV(startCommand: getSelfStartCommand())
        t1000_avElement = CalculateT_1000_AV(startCommand: getSelfStartCommand())
        
        strokes = Training()
        f = Training()
        v = Training()
        s = Training()
    }
    
    //MARK: abstract functions
    func getTrainingEnvironmentType() -> TrainingEnvironmentType {
        fatalError("Must be implemented")
    }
    
    func calculateValues(measureCommands: [E]) -> TelemetryObject {
        fatalError("Must be implemented")
    }
    
    func getSelfStartCommand() -> StartCommand<MeasureCommand> {
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
            v_av: v_avElement!.run(),
            strokes_av: strokesAv!,
            t_200_av: t200_avElement!.run(),
            t_500_av: t500_avElement!.run(),
            t_1000_av: t1000_avElement!.run())
    }
    
    //MARK: timestamp
    func getCalculatedTimeStamp() -> Double {
        return pauseDiff.getAbsoluteTimeStamp()
    }
}
