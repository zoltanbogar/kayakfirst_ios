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
    var latitude: Double = 0
    var longitude: Double = 0
    var speed: Double = 0
    var strokesValue: Double = 0
    
    private var sElement: CalculateElementSOutdoor?
    private var fElement: CalculateElementFOutdoor?
    private var vElement: CalculateElementVOutdoor?
    private var strokeElement: CalculateElementStrokesOutdoor?
    
    private var calculateStrokes_av_outdoor: CalculateStrokes_AV_Outdoor?
    
    //MARK: init
    static let sharedInstance: StartCommandOutdoor = StartCommandOutdoor()
    private override init() {
        //private empty contstructor
    }
    
    override func reset() {
        super.reset()
        
        latitude = 0
        longitude = 0
        speed = 0
        strokesValue = 0
        
        sElement = CalculateElementSOutdoor(startCommand: self)
        fElement = CalculateElementFOutdoor(startCommand: self)
        vElement = CalculateElementVOutdoor(startCommand: self)
        strokeElement = CalculateElementStrokesOutdoor(startCommand: self)
        
        calculateStrokes_av_outdoor = CalculateStrokes_AV_Outdoor(startCommand: self)
    }
    
    override func getTrainingEnvironmentType() -> TrainingEnvironmentType {
        return TrainingEnvironmentType.outdoor
    }
    
    override func getSelfStartCommand() -> StartCommand<MeasureCommand> {
        return self
    }
    
    override func calculateValues(measureCommands: [MeasureCommand]) -> TelemetryObject {
        fillCommands(commands: measureCommands)
        fillHelperValues()
        
        return createTelemetryOjbect()
    }
    
    private func fillCommands(commands: [MeasureCommand]) {
        for measureCommandOutdoor in commands {
            switch measureCommandOutdoor.getCommand() {
            case CommandOutdoorEnum.latitude.rawValue:
                self.latitude = measureCommandOutdoor.value
            case CommandOutdoorEnum.longitude.rawValue:
                self.longitude = measureCommandOutdoor.value
            case CommandOutdoorEnum.speed.rawValue:
                self.speed = measureCommandOutdoor.value
            case CommandOutdoorEnum.stroke.rawValue:
                self.strokesValue = measureCommandOutdoor.value
            default:
                fatalError()
            }
        }
    }
    
    private func fillHelperValues() {
        s = sElement!.run()
        f = fElement!.run()
        v = vElement!.run()
        strokes = strokeElement!.run()
        
        strokesAv = calculateStrokes_av_outdoor?.run()
    }
    
}
