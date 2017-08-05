//
//  Bluetooth.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BluetoothStateChangedListener {
    func stateChanged()
}

protocol BluetoothScanCallback {
    func didDiscover(peripheral: CBPeripheral)
}

class Bluetooth: NSObject, CBCentralManagerDelegate {
    
    //MARK: constants
    private let serviceUuid = CBUUID(string: "0000FFE0-0000-1000-8000-00805F9B34FB")

    //MARK: properties
    var bluetoothManager: CBCentralManager?
    var bluetoothStateChangedListener: BluetoothStateChangedListener?
    
    private var bluetoothScanCallback: BluetoothScanCallback?
    
    //MARK: init
    static let sharedInstance = Bluetooth()
    private override init() {
        //private empty constructor
    }
    
    //MARK: delegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if let listener = bluetoothStateChangedListener {
            listener.stateChanged()
        }
        log("BLE_TEST", "delegate: \(bluetoothManager!.state.rawValue)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let callBack = bluetoothScanCallback {
            callBack.didDiscover(peripheral: peripheral)
        }
    }
    
    //MARK: functions
    func isBluetoothOn() -> Bool? {
        if bluetoothManager == nil {
            turnBluetoothOn()
        }
        
        let state = bluetoothManager!.state
        
        if state == .unknown {
            return nil
        }
        
        return state == .poweredOn
    }
    
    func turnBluetoothOn() {
        let opts = [CBCentralManagerOptionShowPowerAlertKey: true]
        bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: opts)
    }
    
    func startScan(callback: BluetoothScanCallback) {
        self.bluetoothScanCallback = callback
        bluetoothManager!.scanForPeripherals(withServices: [serviceUuid], options: nil)
    }
    
    func stopScan() {
        bluetoothManager!.stopScan()
    }
}
