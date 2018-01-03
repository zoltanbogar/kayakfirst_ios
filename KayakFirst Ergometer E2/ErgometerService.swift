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
    private let startCommandErgometer: StartCommandErgometer
    private let bluetoothService: BluetoothService
    
    //MARK: init
    init(telemetry: Telemetry, bluetooth: Bluetooth) {
        startCommandErgometer = StartCommandErgometer.sharedInstance
        bluetoothService = bluetooth.bluetoothService
        
        super.init(telemetry: telemetry)
    }
    
    override func shouldCalculate() -> Bool {
        var shouldCalculate = false
        
        let telemetryCycleIndex = telemetry.getCycleIndex()
        
        if bluetoothService.checkBluetoothInactiveTimeout() {
            stop()
        }
        
        if bluetoothService.cycleIndex > telemetryCycleIndex {
            telemetry.setCycleIndex(cycleIndex: bluetoothService.cycleIndex, lastCycleIndexTime: bluetoothService.lastCycleIndexTime)
            shouldCalculate = true
        } else if telemetryCycleIndex == 0 && telemetry.duration <= BluetoothService.bluetoothInactiveTime {
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
