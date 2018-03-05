//
//  StartCommandErgometer.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CommandProcessorErgometer: CommandProcessor<MeasureCommandErgometer> {
    
    //MARK: constants
    private let maxNumberToZero: Int64 = 50000000
    
    //MARK: properties
    var t_min: Double = 0
    var t_min_future: Double = 0
    var t_h: Double = 0
    var t_h_future: Double = 0
    var t_max: Double = 0
    
    var p: Double = 0
    var omegaMax: Double = 0
    var omegaMin: Double = 0
    
    private var sElement: CalculateElementSErgo?
    private var fElement: CalculateElementFErgo?
    private var vElement: CalculateElementVErgo?
    private var pElement: CalculateElementP?
    private var omegaMaxElement: CalculateElementOmegaMax?
    private var omegaMinElement: CalculateElementOmegaMin?
    private var strokesElement: CalculateElementStrokesErgo?
    
    private var strokes_av_ergo: CalculateStrokes_AV_Ergo?
    private var v_av_ergo: CalculateV_AV_Ergo?
    
    //MARK: init
    static let sharedInstance = CommandProcessorErgometer()
    private override init() {
        super.init()
        reset()
    }
    
    //MARK: functions
    override func reset() {
        super.reset()
        
        sElement = CalculateElementSErgo(startCommand: self)
        fElement = CalculateElementFErgo(startCommand: self)
        pElement = CalculateElementP(startCommand: self)
        omegaMaxElement = CalculateElementOmegaMax(startCommand: self)
        omegaMinElement = CalculateElementOmegaMin(startCommand: self)
        vElement = CalculateElementVErgo(startCommand: self)
        strokesElement = CalculateElementStrokesErgo(startCommand: self)
        
        strokes_av_ergo = CalculateStrokes_AV_Ergo(startCommand: self)
        v_av_ergo = CalculateV_AV_Ergo(startCommand: self)
        
        t_min = 0
        t_min_future = 0
        t_h = 0
        t_h_future = 0
        t_max = 0
        
        p = 0
        omegaMax = 0
        omegaMin = 0
    }
    
    override func getTrainingEnvironmentType() -> TrainingEnvironmentType {
        return TrainingEnvironmentType.ergometer
    }
    
    override func calculateValues(measureCommands: [MeasureCommandErgometer]) -> Training {
        fillCommands(measureCommands: measureCommands)
        fillHelperValues()
        
        return createTraining()
    }
    
    private func fillCommands(measureCommands: [MeasureCommand]) {
        let cycleIndex = telemetry.getCycleIndex()
        
        for measureCommandErgometer in measureCommands {
            if measureCommandErgometer.getCommand() == CommandEnum.tMin {
                if cycleIndex + 1 == measureCommandErgometer.getCycleIndex() {
                    t_min = t_min_future
                    t_min_future = getDoubleFromCommand(measureCommand: measureCommandErgometer)
                } else if cycleIndex == measureCommandErgometer.getCycleIndex() {
                    t_min = getDoubleFromCommand(measureCommand: measureCommandErgometer)
                }
            } else if measureCommandErgometer.getCommand() == CommandEnum.tH {
                if cycleIndex + 1 == measureCommandErgometer.getCycleIndex() {
                    t_h = t_h_future
                    t_h_future = getDoubleFromCommand(measureCommand: measureCommandErgometer)
                } else if cycleIndex == measureCommandErgometer.getCycleIndex() {
                    t_h = getDoubleFromCommand(measureCommand: measureCommandErgometer)
                }
            }
            if measureCommandErgometer.getCommand() == CommandEnum.tMax {
                t_max = getDoubleFromCommand(measureCommand: measureCommandErgometer)
            }
        }
    }
    
    private func fillHelperValues() {
        omegaMin = omegaMinElement!.run()
        omegaMax = omegaMaxElement!.run()
        p = pElement!.run()
        force = fElement!.run()
        speed = vElement!.run()
        distance = sElement!.run()
        
        strokes = strokesElement!.run()
        strokesAv = strokes_av_ergo!.run()
        speedAv = v_av_ergo!.run()
    }
    
}
