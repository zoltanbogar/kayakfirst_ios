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
class BluetoothList: UIView, BluetoothStateChangedListener, BluetoothScanCallback {
    
    //MARK: constants
    private let bluetoothScanTimeout: Double = 5//5 sec
    
    private let stateBluetoothOff = 0
    private let stateBluetoothFound = 1
    private let stateBluetoothScanningStart = 2
    private let stateBluetoothScanningStop = 3
    
    //MAR: properties
    var btnBluetooth: AppUIButton?
    
    private let bluetooth = Bluetooth.sharedInstance
    private var bluetoothDeviceList: [CBPeripheral]?
    private var isDiscovering = false
    
    //MARK: init
    init() {
        super.init(frame: CGRect.zero)
        initView()
        
        bluetooth.bluetoothStateChangedListener = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        bluetoothTableView.dataList = bluetoothDeviceList
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
        
        progressBar.showProgressBar(false)
        
        setButtonText(text: getString("fragment_bluetooth_button_turn_on"))
        setButtonClickListener(action: #selector(turnBluetoothOnClick))
        
        setEmptyText(text: getString("fragment_bluetooth_off"))
    }
    
    private func setStateBluetoothFound() {
        bluetoothTableView.dataList = bluetoothDeviceList
        
        setButtonText(text: getString("fragment_bluetooth_button_refresh"))
        setButtonClickListener(action: #selector(refreshClick))
        
        setEmptyText(text: getString("fragment_bluetooth_list_empty"))
    }
    
    private func setStateBluetoothScanningStart() {
        progressBar.showProgressBar(true)
        
        setButtonText(text: getString("fragment_bluetooth_button_refresh"))
        setButtonClickListener(action: #selector(refreshClick))
        
        setEmptyText(text: getString("fragment_bluetooth_list_empty"))
    }
    
    private func setStateBluetoothScanningStop() {
        progressBar.showProgressBar(false)
        
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
        bluetoothTableView.emptyText = text
    }
    
    @objc private func refreshClick() {
        refresh()
    }
    
    @objc private func turnBluetoothOnClick() {
        Bluetooth.sharedInstance.turnBluetoothOn()
    }
    
    @objc private func stop() {
        handleState(state: stateBluetoothScanningStop)
        
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
    
    //MARK: init views
    private func initView() {
        addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(margin05)
        }
        
        addSubview(bluetoothTableView)
        bluetoothTableView.snp.makeConstraints { (make) in
            make.top.equalTo(progressBar.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: views
    private lazy var progressBar: AppProgressBar! = {
        let spinner = AppProgressBar()
        
        spinner.isHidden = true
        
        return spinner
    }()
    
    private lazy var bluetoothTableView: BluetoothDeviceTableView! = {
        let view = BluetoothDeviceTableView(view: self)
        
        return view
    }()
    
}
