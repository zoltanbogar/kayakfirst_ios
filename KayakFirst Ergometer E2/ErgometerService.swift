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
    private let startCommandErgometer: CommandProcessorErgometer
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
        startCommandErgometer = CommandProcessorErgometer.sharedInstance
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
    
    override func getTelemetryObject() -> TelemetryObject {
        return startCommandErgometer.calculateValues(measureCommands: bluetoothService.commandList)
    }
    
    override func getTelemetryAvgObject() -> TelemetryAvgObject {
        return startCommandErgometer.calculateAvg()
    }
    
    override func resetServices() {
        bluetoothService.reset()
        
        startCommandErgometer.reset()
    }
    
}
