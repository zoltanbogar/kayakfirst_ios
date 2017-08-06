//
//  ErgometerService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

class ErgometerService: TrainingService, OnBluetoothConnectedListener {
    
    //MARK: constants
    private let bluetoothDisconnectedTime = 2 * 60 * 1000 //2 min
    private let bluetoothInactiveTime = 20 * 1000 //20 sec
    
    //MARK: properties
    private let bluetooth = Bluetooth.sharedInstance
    
    var onBluetoothConnectedListener: OnBluetoothConnectedListener?
    
    //MARK: init
    static let sharedInstance = ErgometerService()
    private override init() {
        super.init()
        telemetry.ergometerCycleStateChangeListener = self
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
    }
    
    //MARK: override abstract methods
    override func reset() {
        //TODO
    }
    
    override func initCommandList() {
        //TODO
    }
    
    override func initStartCommand() {
        //TODO
    }
    
    override func runCommandList() {
        //nothing here
    }
    
    override func handleStopTraining() {
        //nothing here
    }
    
    override func runCalculate() -> Bool {
        //TODO
        return false
    }
    
    override func getTimeWaitAfterCalculate() -> useconds_t {
        return 0
    }
    
    override func onCycleStateChanged(newCycleState: CycleState) {
        //TODO
    }
    
}
