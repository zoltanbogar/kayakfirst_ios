//
//  ErgometerService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ErgometerService: TrainingService {
    
    //MARK: properties
    private let commandProcessErgometer: CommandProcessorErgometer
    private let bluetoothService: BluetoothService
    
    private static var instance: ErgometerService?
    
    class func getInstance(bluetooth: Bluetooth) -> ErgometerService {
        if ErgometerService.instance == nil {
            ErgometerService.instance = ErgometerService(bluetooth: bluetooth)
        }
        return ErgometerService.instance!
    }
    
    //MARK: init
    private init(bluetooth: Bluetooth) {
        commandProcessErgometer = CommandProcessorErgometer.sharedInstance
        bluetoothService = bluetooth.bluetoothService
        
        super.init()
    }
    
    override func shouldCalculate() -> Bool {
        var shouldCalculate = false
        
        let telemetryCycleIndex = telemetry.getCycleIndex()
        
        if bluetoothService.checkBluetoothInactiveTimeout() {
            LogManager.sharedInstance.logStopCycle(stopByWho: "bluetooth inactive timeout")
            stop()
        }
        
        if bluetoothService.cycleIndex > telemetryCycleIndex {
            telemetry.setCycleIndex(cycleIndex: bluetoothService.cycleIndex, lastCycleIndexTime: bluetoothService.lastCycleIndexTime)
            shouldCalculate = true
        }
        
        return shouldCalculate
    }
    
    override func getTrainingObject() -> TrainingNew {
        return commandProcessErgometer.calculateValues(measureCommands: bluetoothService.commandList)
    }
    
    override func getTrainingAvgObject() -> TrainingAvgNew {
        return commandProcessErgometer.calculateAvg()
    }
    
    override func resetServices() {
        bluetoothService.reset()
        
        commandProcessErgometer.reset()
    }
    
}
