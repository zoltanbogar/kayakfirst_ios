//
//  ErgometerService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

class ErgometerService: TrainingService<MeasureCommandErgometer>, OnBluetoothConnectedListener {
    
    //MARK: constants
    private let bluetoothDisconnectedTime: Double = 2 * 60 * 1000 //2 min
    private let bluetoothInactiveTime: Double = 20 * 1000 //20 sec
    private let bluetoothMaxSleep: Double = 300 //300 millisec
    
    //MARK: properties
    private let bluetooth = Bluetooth.sharedInstance
    
    var onBluetoothConnectedListener: OnBluetoothConnectedListener?
    
    private var commandErgometerReset: CommandErgometerReset?
    private var commandErgometerRPM: CommandErgometerRPM?
    private var commandErgometerT_h: CommandErgometerT_H?
    private var commandErgometerT_max: CommandErgometerT_MAX?
    private var commandErgometerT_min: CommandErgometerT_MIN?
    private var commandErgometerT_v: CommandErgometerT_V?
    
    private var commandIndex: Int = 0
    private var bluetoothResetNumber = 0
    
    private var cycleIndex: Int64 = 0
    private var lastCycleIndexTime: Double = 0
    
    private var inactiveDisconnectTime: Double = 0
    private var inactiveTime: Double = 0
    
    private var dataAvailableTime: Double = 0
    private var maDataAvailableTime = MovingAverage()
    private var avgDataAvailableTime: Double = 0
    
    //MARK: init
    static let sharedInstance = ErgometerService()
    private override init() {
        super.init()
        initConnection()
    }
    
    //MARK: functions
    func connectBluetooth(bluetoothDevice: CBPeripheral) {
        bluetooth.connect(bluetoothDevice: bluetoothDevice)
    }
    
    func disconnectBluetoothn() {
        bluetooth.disconnect()
    }
    
    private func initConnection() {
        bluetooth.onBluetoothConnectedListener = self
    }
    
    //MARK: delegeta
    func onConnected() {
        setTelemetryListener(true)
        telemetry.cycleState = CycleState.idle
        
        if let listener = onBluetoothConnectedListener {
            listener.onConnected()
        }
    }
    
    func onDisconnected() {
        stopCycle()
        
        if let listener = onBluetoothConnectedListener {
            listener.onDisconnected()
        }
        
        setTelemetryListener(false)
    }
    
    func onDataAvailable(stringData: String) {
        if dataAvailableTime == 0 {
            dataAvailableTime = pauseDiff.getAbsoluteTimeStamp()
        }
        
        let timeDiff = pauseDiff.getAbsoluteTimeStamp() - dataAvailableTime
        
        var diffAvg: Double = Double(abs(timeDiff - avgDataAvailableTime))
        
        avgDataAvailableTime = maDataAvailableTime.calAverage(newValue: timeDiff)
        
        if diffAvg > bluetoothMaxSleep {
            diffAvg = bluetoothMaxSleep
        }
        
        let sleepTime: Int = Int(diffAvg * 1000)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(sleepTime), execute: {
            self.dataAvailableTime = self.pauseDiff.getAbsoluteTimeStamp()
            
            let command = self.commandList![self.commandIndex]
            
            command.setValue(stringValue: stringData)
            
            if self.commandIndex == 0 {
                if command.getValue() == Double(self.commandErgometerReset!.resetSuccess) {
                    self.commandIndex = 1
                    self.bluetoothResetNumber = 0
                } else {
                    self.bluetoothResetNumber += 1
                }
                
                if self.bluetoothResetNumber == self.commandErgometerReset?.tryResetNumber {
                    self.bluetoothResetNumber = 0
                    self.handleStopTraining()
                }
            } else {
                if self.commandIndex == self.commandList!.count - 1 {
                    self.setCycleIndex(cycleIndex: command.getCycleIndex(), timestampDiff: diffAvg)
                    self.commandIndex = 0
                }
                self.commandIndex = self.commandIndex + 1
            }
            
            self.writeBluetoothData()
        })
    }
    
    private func writeBluetoothData() {
        checkBluetoothDisconnectTimeout()
        
        bluetooth.writeData(meausreCommandErgometer: commandList![commandIndex])
    }
    
    //MARK: override abstract methods
    override func reset() {
        super.reset()
        
        cycleIndex = 0
        lastCycleIndexTime = 0
        inactiveDisconnectTime = 0
        inactiveTime = 0
        
        dataAvailableTime = 0
        maDataAvailableTime = MovingAverage(numAverage: 5)
        avgDataAvailableTime = 0
    }
    
    override func initCommandList() {
        commandErgometerReset = CommandErgometerReset()
        commandErgometerRPM = CommandErgometerRPM()
        commandErgometerT_h = CommandErgometerT_H()
        commandErgometerT_max = CommandErgometerT_MAX()
        commandErgometerT_min = CommandErgometerT_MIN()
        commandErgometerT_v = CommandErgometerT_V()
        
        commandIndex = 0
        bluetoothResetNumber = 0
        
        commandList = [
            commandErgometerReset!,
            commandErgometerRPM!,
            commandErgometerT_min!,
            commandErgometerT_h!,
            commandErgometerT_max!,
            commandErgometerT_v!
        ]
    }
    
    override func initStartCommand() {
        startCommand = StartCommandErgometer.sharedInstance
    }
    
    override func runCommandList() {
        //nothing here
    }
    
    override func handleStopTraining() {
        //nothing here
    }
    
    override func runCalculate() -> Bool {
        let telemetryCycleIndex = telemetry.getCycleIndex()
        
        runCommandList()
        
        checkBluetoothInactiveTimeout()
        
        if cycleIndex > telemetryCycleIndex {
            telemetry.setCycleIndex(cycleIndex: cycleIndex, lastCycleIndexTime: lastCycleIndexTime)
            return true
        } else if telemetryCycleIndex == 0 && telemetry.duration <= bluetoothInactiveTime {
            return true
        }
    
        return false
    }
    
    override func getTimeWaitAfterCalculate() -> useconds_t {
        return 0
    }
    
    private func setCycleIndex(cycleIndex: Int64, timestampDiff: Double) {
        self.cycleIndex = pauseDiff.getAbsoluteCycleIndex(cycleIndex: cycleIndex)
        self.lastCycleIndexTime = pauseDiff.getAbsoluteTimeStamp() - timestampDiff
    }
    
    override func onCycleStateChanged(newCycleState: CycleState) {
        if !isServiceStopped {
            super.onCycleStateChanged(newCycleState: newCycleState)
            
            if CycleState.idle == newCycleState {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(300000), execute: {
                    self.writeBluetoothData()
                })
            }
        }
    }
    
    private func checkBluetoothDisconnectTimeout() {
        if cycleIndex == telemetry.getCycleIndex() {
            if inactiveDisconnectTime == 0 {
                inactiveDisconnectTime = currentTimeMillis()
            }
            
            let timeDiff = currentTimeMillis() - inactiveDisconnectTime
            
            if timeDiff > bluetoothDisconnectedTime {
                disconnectBluetoothn()
            }
        } else {
            inactiveDisconnectTime = 0
        }
    }
    
    private func checkBluetoothInactiveTimeout() {
        if cycleIndex == telemetry.getCycleIndex() {
            if inactiveTime == 0 {
                inactiveTime = pauseDiff.getAbsoluteTimeStamp()
            }
            
            let timeDiff = pauseDiff.getAbsoluteTimeStamp() - inactiveTime
            
            if timeDiff > bluetoothInactiveTime {
                stopCycle()
            }
        } else {
            inactiveTime = 0
        }
    }
    
}
