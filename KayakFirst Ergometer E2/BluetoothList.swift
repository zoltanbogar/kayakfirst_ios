//
//  BluetoothList.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

//TODO - refactor: BaseView class for the init stuffs
class BluetoothList: CustomUi<ViewBluetoothListLayout>, BluetoothStateChangedListener, BluetoothScanCallback {
    
    //MARK: constants
    private let bluetoothScanTimeout: Double = 5 //5 sec
    private let bluetoothConnectTimeout: Double = 5 //5 sec
    
    private let stateBluetoothOff = 0
    private let stateBluetoothFound = 1
    private let stateBluetoothScanningStart = 2
    private let stateBluetoothScanningStop = 3
    
    //MAR: properties
    var btnBluetooth: AppUIButton?
    
    private let bluetooth = Bluetooth.sharedInstance
    private var bluetoothDeviceList: [CBPeripheral]?
    private var isDiscovering = false
    
    private var trainingViewController: TrainingViewControllerOld
    
    //MARK: init
    init(trainingViewController: TrainingViewControllerOld) {
        self.trainingViewController = trainingViewController
        super.init()
        
        bluetooth.bluetoothStateChangedListener = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getContentLayout(contentView: UIView) -> ViewBluetoothListLayout {
        return ViewBluetoothListLayout(contentView: contentView)
    }
    
    //MARK: init views
    override func initView() {
        super.initView()
        
        contentLayout!.bluetoothTableView.rowClickCallback = { bluetoothDevice, position in
            self.trainingViewController.connectBluetooth(bluetoothDevice: bluetoothDevice)
            self.setBluetoothDisconnectTimeout()
            self.stop()
        }
    }
    
    //MARK: delegate
    func stateChanged() {
        refresh()
    }
    
    func didDiscover(peripheral: CBPeripheral) {
        addDeviceToList(peripheral: peripheral)
    }
    
    //MARK: functions
    func refresh() {
        let isBluetoothOn = Bluetooth.sharedInstance.isBluetoothOn()
        
        if isBluetoothOn == nil {
            return
        }
        
        if isBluetoothOn! {
            discoveryBluetoothDevices()
        } else {
            handleState(state: stateBluetoothOff)
        }
    }
    
    private func discoveryBluetoothDevices() {
        if !isDiscovering {
            isDiscovering = true
            
            resetDeviceList()
            
            handleState(state: stateBluetoothScanningStart)
            
            bluetooth.startScan(callback: self)
            
            Timer.scheduledTimer(timeInterval: bluetoothScanTimeout, target: self, selector: #selector(stop), userInfo: nil, repeats: false)
        }
    }
    
    private func addDeviceToList(peripheral: CBPeripheral) {
        if peripheral.name != nil && isDeviceNameValid(deviceName: peripheral.name!) {
            
            var isContain = false
            
            for p in bluetoothDeviceList! {
                if p.name != nil && p.name! == peripheral.name! {
                    isContain = true
                    break
                }
            }
            
            if !isContain {
                bluetoothDeviceList?.append(peripheral)
            }
            
            if bluetoothDeviceList!.count > 0 {
                DispatchQueue.main.async {
                    self.handleState(state: self.stateBluetoothFound)
                }
            }
        }
    }
    
    private func resetDeviceList() {
        bluetoothDeviceList = [CBPeripheral]()
        contentLayout!.bluetoothTableView.dataList = bluetoothDeviceList
    }
    
    private func handleState(state: Int) {
        switch state {
        case stateBluetoothOff:
            setStateBluetoothOff()
            break
        case stateBluetoothFound:
            setStateBluetoothFound()
            break
        case stateBluetoothScanningStart:
            setStateBluetoothScanningStart()
            break
        case stateBluetoothScanningStop:
            setStateBluetoothScanningStop()
            break
        default:
            break
        }
    }
    
    private func setStateBluetoothOff() {
        resetDeviceList()
        
        contentLayout!.progressBar.showProgressBar(false)
        
        setButtonText(text: getString("fragment_bluetooth_button_turn_on"))
        setButtonClickListener(action: #selector(turnBluetoothOnClick))
        
        setEmptyText(text: getString("fragment_bluetooth_off"))
    }
    
    private func setStateBluetoothFound() {
        contentLayout!.bluetoothTableView.dataList = bluetoothDeviceList
        
        setButtonText(text: getString("fragment_bluetooth_button_refresh"))
        setButtonClickListener(action: #selector(refreshClick))
        
        setEmptyText(text: getString("fragment_bluetooth_list_empty"))
    }
    
    private func setStateBluetoothScanningStart() {
        contentLayout!.progressBar.showProgressBar(true)
        
        setButtonText(text: getString("fragment_bluetooth_button_refresh"))
        setButtonClickListener(action: #selector(refreshClick))
        
        setEmptyText(text: getString("fragment_bluetooth_list_empty"))
    }
    
    private func setStateBluetoothScanningStop() {
        contentLayout!.progressBar.showProgressBar(false)
        
        setButtonText(text: getString("fragment_bluetooth_button_refresh"))
        setButtonClickListener(action: #selector(refreshClick))
        
        setEmptyText(text: getString("fragment_bluetooth_list_empty"))
    }
    
    private func setButtonText(text: String) {
        btnBluetooth?.text = text
    }
    
    private func setButtonClickListener(action: Selector) {
        btnBluetooth?.addTarget(self, action: action, for: .touchUpInside)
    }
    
    private func setEmptyText(text: String) {
        contentLayout!.bluetoothTableView.emptyText = text
    }
    
    @objc private func refreshClick() {
        refresh()
    }
    
    @objc private func turnBluetoothOnClick() {
        Bluetooth.sharedInstance.turnBluetoothOn()
    }
    
    @objc private func stop() {
        if bluetooth.isBluetoothOn() != nil && bluetooth.isBluetoothOn()! {
            handleState(state: stateBluetoothScanningStop)
        }
        
        bluetooth.stopScan()
        
        isDiscovering = false
    }
    
    private func isDeviceNameValid(deviceName: String) -> Bool {
        if !logNeeded {
            let kayakDeviceCharacters = 8
            let kayakDeviceFirstLetter = "B"
            
            return deviceName.hasPrefix(kayakDeviceFirstLetter) && deviceName.characters.count == kayakDeviceCharacters
        }
        return true
    }
    
    private func setBluetoothDisconnectTimeout() {
        Timer.scheduledTimer(timeInterval: bluetoothConnectTimeout, target: self, selector: #selector(bluetoothConnectTimeouted), userInfo: nil, repeats: false)
    }
    
    @objc private func bluetoothConnectTimeouted() {
        let bluetooth = Bluetooth.sharedInstance
        
        if !bluetooth.isConnected {
            bluetooth.disconnect()
            self.trainingViewController.progressView?.show(false)
            self.trainingViewController.bluetoothViewController?.refreshBluetoothList()
        }
        
    }
    
}
