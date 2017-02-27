//
//  OutdoorService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class OutdoorService: TrainingService {
    
    //MARK: properties
    private let fusedLocationManager = FusedLocationManager.sharedInstance
    private let sensorManager = AppSensorManager.sharedInstance
    
    private var commandOutdoorLatitude: CommandOutdoorLatitude?
    private var commandOutdoorLongitude: CommandOutdoorLongitude?
    private var commandOutdoorSpeed: CommandOutdoorSpeed?
    private var commandOutdoorStroke: CommandOutdoorStroke?
    
    //MARK: init
    static let sharedInstance = OutdoorService()
    private override init() {
        //private empty constructor
    }
    
    //MARK: start/stop monitoring
    func startLocationMonitoring() {
        fusedLocationManager.startLocationMonitoring(start: true)
        sensorManager.startSensorMonitoring(start: true)
    }
    
    func stopLocationMonitoring() {
        fusedLocationManager.startLocationMonitoring(start: false)
        sensorManager.startSensorMonitoring(start: false)
    }
    
    func startDashboard() {
        startTrainig()
    }
    
    func stopDashboard() {
        stopTraining()
    }
    
    override func initCommandList() {
        commandOutdoorLatitude = CommandOutdoorLatitude()
        commandOutdoorLongitude = CommandOutdoorLongitude()
        commandOutdoorSpeed = CommandOutdoorSpeed()
        commandOutdoorStroke = CommandOutdoorStroke()
        
        sensorManager.reset()
        
        commandList = [commandOutdoorLatitude!, commandOutdoorLongitude!, commandOutdoorSpeed!, commandOutdoorStroke!]
    }
    
    override func initStartCommand() {
        startCommand = StartCommandOutdoor.sharedInstance
    }
    
    override func runCommandList() {
        let location = fusedLocationManager.currentLocation
        if let locationValue = location {
            commandOutdoorLatitude!.value = locationValue.coordinate.latitude
            commandOutdoorLongitude!.value = locationValue.coordinate.longitude
            //TODO: it can be negative
            commandOutdoorSpeed!.value = locationValue.speed
            commandOutdoorStroke!.value = Double(sensorManager.cycleIndex)
            
            setCycleIndex(cycleIndex: commandOutdoorStroke!.getCycleIndex())
        }
    }
    
    override func isNewCycle() -> Bool {
        runCommandList()
        return true
    }
}
