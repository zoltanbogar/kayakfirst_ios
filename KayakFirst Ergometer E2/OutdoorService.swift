//
//  OutdoorService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class OutdoorSevice: TrainingService {
    
    //MARK: properties
    private let locationService: FusedLocationManager
    private let sensorManager: AppSensorManager
    
    private let startCommandOutdoor: CommandProcessorOutdoor
    
    private static var instance: OutdoorSevice?
    
    class func getInstance() -> OutdoorSevice {
        if OutdoorSevice.instance == nil {
            OutdoorSevice.instance = OutdoorSevice()
        }
        OutdoorSevice.instance!.reset()
        return OutdoorSevice.instance!
    }
    
    private override init() {
        locationService = FusedLocationManager.sharedInstance
        sensorManager = AppSensorManager.sharedInstance
        
        startCommandOutdoor = CommandProcessorOutdoor.sharedInstance
        
        super.init()
    }
    
    override func getCalibrationDuration() -> Double {
        return analyzeTime
    }
    
    override func calibrate() {
        locationService.startLocationMonitoring(start: true)
        sensorManager.calibrate()
    }
    
    override func onResumed() {
        super.onResumed()
        
        startLocationMonitoring()
    }
    
    override func onStopped() {
        super.onStopped()
        
        stopLocationMonitoring()
    }
    
    override func getTelemetryObject() -> TelemetryObject {
        return startCommandOutdoor.calculate(measureCommands: locationService.getCommandList(appSensorManager: sensorManager))
    }
    
    override func getTelemetryAvgObject() -> TelemetryAvgObject {
        return startCommandOutdoor.calculateAvg()
    }
    
    override func resetServices() {
        startCommandOutdoor.reset()
    }
    
    override func shouldCalculate() -> Bool {
        return locationService.isNewLocationAvailable
    }
    
    private func startLocationMonitoring() {
        sensorManager.startSensorMonitoring(start: true)
    }
    
    private func stopLocationMonitoring() {
        locationService.startLocationMonitoring(start: false)
        sensorManager.startSensorMonitoring(start: false)
    }
    
}
