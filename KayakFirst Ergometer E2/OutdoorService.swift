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
    
    override init(telemetry: Telemetry) {
        locationService = FusedLocationManager.sharedInstance
        sensorManager = AppSensorManager.sharedInstance
        
        startCommandOutdoor = CommandProcessorOutdoor.sharedInstance
        
        super.init(telemetry: telemetry)
    }
    
    override func getCalibrationDuration() -> Double {
        return analyzeTime
    }
    
    override func calibrate() {
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
        //nothing here
    }
    
    override func shouldCalculate() -> Bool {
        return locationService.isNewLocationAvailable
    }
    
    private func startLocationMonitoring() {
        locationService.startLocationMonitoring(start: true)
        sensorManager.startSensorMonitoring(start: true)
    }
    
    private func stopLocationMonitoring() {
        locationService.startLocationMonitoring(start: false)
        sensorManager.startSensorMonitoring(start: false)
    }
    
    private func getTimeBasedMaxSpm() -> useconds_t {
        let maxSpm = AppSensorManager.maxSpm
        
        let timeWait = useconds_t((Double(1000) / (Double(maxSpm) / Double(60)))) * 1000
        
        return timeWait
    }
    
}
