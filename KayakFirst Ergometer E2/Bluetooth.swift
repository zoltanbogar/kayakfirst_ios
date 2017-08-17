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

protocol OnBluetoothConnectedListener {
    func onConnected()
    
    func onDisconnected()
    
    func onDataAvailable(stringData: String)
}

class Bluetooth: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //MARK: constants
    private let serviceUuid = CBUUID(string: "0000FFE0-0000-1000-8000-00805F9B34FB")
    private let characteristicUuid = CBUUID(string: "0000FFE1-0000-1000-8000-00805F9B34FB")

    //MARK: properties
    var bluetoothManager: CBCentralManager?
    var bluetoothStateChangedListener: BluetoothStateChangedListener?
    var onBluetoothConnectedListener: OnBluetoothConnectedListener?
    
    private var bluetoothScanCallback: BluetoothScanCallback?
    
    private var connectedPeripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    
    private var isConnected = false
    
    //MARK: init
    static let sharedInstance = Bluetooth()
    private override init() {
        //private empty constructor
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
    
    func connect(bluetoothDevice: CBPeripheral) {
        if isBluetoothOn() != nil && isBluetoothOn()! {
            bluetoothManager?.connect(bluetoothDevice, options: nil)
        }
    }
    
    func disconnect() {
        if let peripheral = connectedPeripheral {
            isConnected = false
            bluetoothManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    func writeData(meausreCommandErgometer: MeasureCommandErgometer) {
        if isConnected && connectedPeripheral != nil {
            connectedPeripheral?.writeValue(meausreCommandErgometer.getCommand().data(using: String.Encoding.utf8)!, for: characteristic!, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    private func parseData(data: Data?) -> String {
        var stringValue: String = ""
        if let dataValue = data {
            //TODO
            stringValue = String(data: dataValue, encoding: String.Encoding.utf8)!
        }
        return stringValue
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
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
        self.characteristic = nil
        
        isConnected = false
        
        if let listener = onBluetoothConnectedListener {
            listener.onDisconnected()
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == serviceUuid {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristicUuid == characteristic.uuid {
                    connectedPeripheral = peripheral
                    self.characteristic = characteristic
                    
                    connectedPeripheral?.setNotifyValue(true, for: characteristic)
                    
                    isConnected = true
                    
                    if let listener = onBluetoothConnectedListener {
                        listener.onConnected()
                    }
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let listener = onBluetoothConnectedListener {
            listener.onDataAvailable(stringData: parseData(data: characteristic.value))
        }
    }
}
