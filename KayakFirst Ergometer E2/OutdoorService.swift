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
    
    private var commandOutdoorDistance: CommandOutdoorDistance?
    private var commandOutdoorSpeed: CommandOutdoorSpeed?
    private var commandOutdoorStroke: CommandOutdoorStroke?
    
    //MARK: init
    static let sharedInstance = OutdoorService()
    private override init() {
        //private empty constructor
    }
    
    //MARK: start/stop monitoring
    private func startLocationMonitoring() {
        fusedLocationManager.startLocationMonitoring(start: true)
        sensorManager.startSensorMonitoring(start: true)
    }
    
    private func stopLocationMonitoring() {
        fusedLocationManager.startLocationMonitoring(start: false)
        sensorManager.startSensorMonitoring(start: false)
    }
    
    override func initCommandList() {
        commandOutdoorDistance = CommandOutdoorDistance()
        commandOutdoorSpeed = CommandOutdoorSpeed()
        commandOutdoorStroke = CommandOutdoorStroke()
        
        sensorManager.reset()
        fusedLocationManager.reset()
        
        commandList = [commandOutdoorDistance!, commandOutdoorSpeed!, commandOutdoorStroke!]
    }
    
    override func initStartCommand() {
        startCommand = StartCommandOutdoor.sharedInstance
    }
    
    override func runCommandList() {
        commandOutdoorDistance!.value = fusedLocationManager.distanceSum
        commandOutdoorSpeed!.value = fusedLocationManager.speed
        commandOutdoorStroke!.value = Double(sensorManager.strokesPerMin)
    }
    
    override func handleStartTraining() {
        startLocationMonitoring()
    }
    
    override func handleStopTraining() {
        stopLocationMonitoring()
    }
    
    override func runCalculate() -> Bool {
        runCommandList()
        return true
    }
    
    override func shouldWaitAfterCalculate() -> Bool {
        return true
    }
}
