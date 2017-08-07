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
    
    private var inactiveDisconnectTime: Double = 0
    private var inactiveTime: Double = 0
    
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
    }
    
    func onDataAvailable(stringData: String) {
        //TODO
        log("BLE_TEST", "dataAvailableErgometerService: \(stringData)")
    }
    
    private func writeBluetoothData() {
        //TODO
    }
    
    //MARK: override abstract methods
    override func reset() {
        super.reset()
        
        cycleIndex = 0
        inactiveDisconnectTime = 0
        inactiveTime = 0
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
        let telemetryCycleIndex = telemetry.cycleIndex
        
        runCommandList()
        
        checkBluetoothInactiveTimeout()
        
        if cycleIndex > telemetryCycleIndex {
            telemetry.cycleIndex = cycleIndex
            return true
        } else if telemetryCycleIndex == 0 && telemetry.duration <= bluetoothInactiveTime {
            return true
        }
    
        return false
    }
    
    override func getTimeWaitAfterCalculate() -> useconds_t {
        return 0
    }
    
    override func onCycleStateChanged(newCycleState: CycleState) {
        if !isServiceStopped {
            super.onCycleStateChanged(newCycleState: newCycleState)
            
            if CycleState.idle == newCycleState {
                usleep(300000)
                
                writeBluetoothData()
            }
        }
    }
    
    private func checkBluetoothDisconnectTimeout() {
        if cycleIndex == telemetry.cycleIndex {
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
        if cycleIndex == telemetry.cycleIndex {
            if inactiveTime == 0 {
                inactiveTime = currentTimeMillis()
            }
            
            let timeDiff = currentTimeMillis() - inactiveTime
            
            if timeDiff > bluetoothInactiveTime {
                stopCycle()
            }
        } else {
            inactiveTime = 0
        }
    }
    
}
