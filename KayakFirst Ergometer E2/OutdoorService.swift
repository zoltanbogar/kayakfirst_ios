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
    
    private let commandProcessorOutdoor: CommandProcessorOutdoor
    
    private var gpsAvailableListener: GpsAvailableListener? {
        didSet {
            locationService.gpsAvailableListener = gpsAvailableListener
        }
    }
    
    private static var instance: OutdoorSevice?
    
    class func getInstance(gpsAvailableListener: GpsAvailableListener) -> OutdoorSevice {
        if OutdoorSevice.instance == nil {
            OutdoorSevice.instance = OutdoorSevice()
        }
        OutdoorSevice.instance!.gpsAvailableListener = gpsAvailableListener
        return OutdoorSevice.instance!
    }
    
    private override init() {
        locationService = FusedLocationManager.sharedInstance
        sensorManager = AppSensorManager.sharedInstance
        
        commandProcessorOutdoor = CommandProcessorOutdoor.sharedInstance
        
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
    
    override func getTrainingObject() -> TrainingNew {
        return commandProcessorOutdoor.calculate(measureCommands: locationService.getCommandList(appSensorManager: sensorManager))
    }
    
    override func getTrainingAvgObject() -> TrainingAvgNew {
        return commandProcessorOutdoor.calculateAvg()
    }
    
    override func resetServices() {
        commandProcessorOutdoor.reset()
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
