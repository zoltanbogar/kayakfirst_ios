//
//  BluetoothService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BluetoothService {
    
    //MARK: constants
    private let bluetoothDisconnectedTime: Double = 2 * 60 * 1000 //2 min
    static let bluetoothInactiveTime: Double = 60 * 1000 //60 sec
    private let bluetoothMaxSleep: Double = 300 //300 millisec
    
    //MARK: properties
    private let bluetooth: Bluetooth
    private let telemetry: Telemetry
    
    let commandList: [MeasureCommandErgometer]
    
    private var isStarted = false
    
    private var commandIndex: Int = 0
    private var bluetoothResetNumber = 0
    
    var cycleIndex: Int64 = 0
    var lastCycleIndexTime: Double = 0
    
    private var inactiveDisconnectTime: Double = 0
    private var inactiveTime: Double = 0
    
    private var dataAvailableTime: Double = 0
    private var maDataAvailableTime = MovingAverage()
    private var avgDataAvailableTime: Double = 0
    
    private let logManager = LogManager.sharedInstance
    
    
    //MARK: init
    private static var instance: BluetoothService?
    class func getInstance(bluetooth: Bluetooth, telemetry: Telemetry) -> BluetoothService {
        if BluetoothService.instance == nil {
            BluetoothService.instance = BluetoothService(bluetooth: bluetooth, telemetry: telemetry)
        }
        return BluetoothService.instance!
    }
    private init(bluetooth: Bluetooth, telemetry: Telemetry) {
        self.bluetooth = bluetooth
        self.telemetry = telemetry
        
        let commandErgometerReset = CommandErgometerReset()
        let commandErgometerT_h = CommandErgometerT_H()
        let commandErgometerT_max = CommandErgometerT_MAX()
        let commandErgometerT_min = CommandErgometerT_MIN()
        let commandErgometerT_v = CommandErgometerT_V()
        
        commandList = [
            commandErgometerReset,
            commandErgometerT_min,
            commandErgometerT_h,
            commandErgometerT_max,
            commandErgometerT_v]
    }
    
    //MARK: functions
    func reset() {
        commandIndex = 0
        bluetoothResetNumber = 0
        
        cycleIndex = 0
        lastCycleIndexTime = 0
        inactiveDisconnectTime = 0
        inactiveTime = 0
        
        dataAvailableTime = 0
        maDataAvailableTime = MovingAverage(numAverage: 5)
        avgDataAvailableTime = 0
    }
    
    func checkBluetoothInactiveTimeout() -> Bool {
        if cycleIndex == telemetry.getCycleIndex() {
         if inactiveTime == 0 {
            inactiveTime = telemetry.getAbsoluteTimestamp()
         }
         
         let timeDiff = telemetry.getAbsoluteTimestamp() - inactiveTime
         
            if timeDiff > BluetoothService.bluetoothInactiveTime {
            return true
         }
         } else {
            inactiveTime = 0
         }
        return false
    }
    
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(300000), execute: {
            self.reset()
            self.isStarted = true
            self.writeBluetoothData()
        })
    }
    
    func stop() {
        isStarted = false
    }
    
    func onDataAvailable(stringData: String) {
        if dataAvailableTime == 0 {
            dataAvailableTime = telemetry.getAbsoluteTimestamp()
        }
         
        let timeDiff = telemetry.getAbsoluteTimestamp() - dataAvailableTime
         
        var diffAvg: Double = Double(abs(timeDiff - avgDataAvailableTime))
         
        avgDataAvailableTime = maDataAvailableTime.calAverage(newValue: timeDiff)
         
        if diffAvg > bluetoothMaxSleep {
            diffAvg = bluetoothMaxSleep
        }
         
        let sleepTime: Int = Int(diffAvg * 1000)
         
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(sleepTime), execute: {
            self.dataAvailableTime = self.telemetry.getAbsoluteTimestamp()
         
            let command = self.commandList[self.commandIndex]
         
            let valueWasParsable = command.setValue(stringValue: stringData)
         
            if self.commandIndex == 0 {
                if command.getValue() == CommandErgometerReset.resetSuccess {
                    self.commandIndex = 1
                    self.bluetoothResetNumber = 0
                } else {
                    self.bluetoothResetNumber += 1
                }
         
                if self.bluetoothResetNumber == CommandErgometerReset.tryResetNumber {
                    self.bluetoothResetNumber = 0
                    self.logManager.logBtDisconnect(disconnectByWho: "reset not success")
                    self.disconnectBluetooth()
                }
            } else {
                if self.commandIndex == self.commandList.count - 1 {
                    self.setCycleIndex(cycleIndex: command.getCycleIndex(), timestampDiff: diffAvg)
                    self.commandIndex = 0
                    
                    self.logManager.logErgoCommandList(commandList: self.commandList)
                }
                if valueWasParsable {
                    self.commandIndex = self.commandIndex + 1
                }
            }
         
            if self.isStarted {
                self.writeBluetoothData()
            }
         })
    }
    
    private func setCycleIndex(cycleIndex: Int64, timestampDiff: Double) {
        self.cycleIndex = telemetry.getAbsoluteCycleIndex(cycleIndex: cycleIndex)
        self.lastCycleIndexTime = telemetry.getAbsoluteTimestamp() - timestampDiff
    }
    
    private func writeBluetoothData() {
        checkBluetoothDisconnectTimeout()
        
        bluetooth.writeData(meausreCommandErgometer: commandList[commandIndex])
    }
    
    private func checkBluetoothDisconnectTimeout() {
        if cycleIndex == telemetry.getCycleIndex() {
            if inactiveDisconnectTime == 0 {
                inactiveDisconnectTime = currentTimeMillis()
            }
            
            let timeDiff = currentTimeMillis() - inactiveDisconnectTime
            
            if timeDiff > bluetoothDisconnectedTime {
                logManager.logBtDisconnect(disconnectByWho: "inactive timeout")
                disconnectBluetooth()
            }
        } else {
            inactiveDisconnectTime = 0
        }
    }
    
    private func disconnectBluetooth() {
        bluetooth.disconnect()
    }
    
}
