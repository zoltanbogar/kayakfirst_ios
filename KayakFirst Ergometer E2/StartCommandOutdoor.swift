//
//  StartCommandOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class StartCommandOutdoor: StartCommand<MeasureCommand> {
    
    //MARK: properties
    var speed: Double = 0
    var strokesValue: Double = 0
    
    private var sElement: CalculateElementSOutdoor?
    private var fElement: CalculateElementFOutdoor?
    private var vElement: CalculateElementVOutdoor?
    private var strokeElement: CalculateElementStrokesOutdoor?
    
    private var calculateStrokes_av_outdoor: CalculateStrokes_AV_Outdoor?
    private var calculateV_av_outdoor: CalculateV_AV_Outdoor?
    
    //MARK: init
    static let sharedInstance: StartCommandOutdoor = StartCommandOutdoor()
    private override init() {
        super.init()
        reset()
    }
    
    override func reset() {
        super.reset()
        
        distanceSum = 0
        speed = 0
        strokesValue = 0
        
        sElement = CalculateElementSOutdoor(startCommand: self)
        fElement = CalculateElementFOutdoor(startCommand: self)
        vElement = CalculateElementVOutdoor(startCommand: self)
        strokeElement = CalculateElementStrokesOutdoor(startCommand: self)
        
        calculateStrokes_av_outdoor = CalculateStrokes_AV_Outdoor(startCommand: self)
        calculateV_av_outdoor = CalculateV_AV_Outdoor(startCommand: self)
    }
    
    override func getTrainingEnvironmentType() -> TrainingEnvironmentType {
        return TrainingEnvironmentType.outdoor
    }
    
    override func calculateValues(measureCommands: [MeasureCommand]) -> TelemetryObject {
        fillCommands(commands: measureCommands)
        fillHelperValues()
        
        return createTelemetryOjbect()
    }
    
    private func fillCommands(commands: [MeasureCommand]) {
        for measureCommandOutdoor in commands {
            //TODO
            /*switch measureCommandOutdoor.getCommand() {
            case CommandEnum.distance:
                self.distanceSum = measureCommandOutdoor.value
            case CommandEnum.speed:
                self.speed = measureCommandOutdoor.value
            case CommandEnum.stroke:
                self.strokesValue = measureCommandOutdoor.value
            default:
                fatalError()
            }*/
        }
    }
    
    private func fillHelperValues() {
        s = sElement!.run()
        f = fElement!.run()
        v = vElement!.run()
        strokes = strokeElement!.run()
        
        strokesAv = calculateStrokes_av_outdoor?.run()
        vAv = calculateV_av_outdoor!.run()
    }
    
}
