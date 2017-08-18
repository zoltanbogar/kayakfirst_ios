//
//  OutdoorService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class OutdoorService: TrainingService<MeasureCommand> {
    
    //MARK: properties
    private let fusedLocationManager = FusedLocationManager.sharedInstance
    private let sensorManager = AppSensorManager.sharedInstance
    
    private var commandOutdoorDistance: CommandOutdoorDistance?
    private var commandOutdoorSpeed: CommandOutdoorSpeed?
    private var commandOutdoorStroke: CommandOutdoorStroke?
    
    //MARK: init
    static let sharedInstance = OutdoorService()
    private override init() {
        super.init()
    }
    
    //MARK: start/stop monitoring
    public func startLocationMonitoring() {
        setTelemetryListener(true)
        fusedLocationManager.startLocationMonitoring(start: true)
        sensorManager.startSensorMonitoring(start: true)
    }
    
    public func stopLocationMonitoring() {
        fusedLocationManager.startLocationMonitoring(start: false)
        sensorManager.startSensorMonitoring(start: false)
        setTelemetryListener(false)
    }
    
    override func initCommandList() {
        commandOutdoorDistance = CommandOutdoorDistance()
        commandOutdoorSpeed = CommandOutdoorSpeed()
        commandOutdoorStroke = CommandOutdoorStroke()
        
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
    
    override func handleStopTraining() {
        stopLocationMonitoring()
    }
    
    override func getTimeWaitAfterCalculate() -> useconds_t {
        return getTimeBasedMaxSpm() * 2
    }
    
    override func runCalculate() -> Bool {
        runCommandList()
        //TODO - refactor: test this
        //return fusedLocationManager.isNewLocationAvailable
        return true
    }
}
