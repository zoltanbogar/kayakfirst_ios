//
//  BluetoothViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

func startBluetoothVc(viewController: UIViewController, plan: Plan?, event: Event?) {
    let bluetoothVc = BluetoothViewController()
    bluetoothVc.plan = plan
    bluetoothVc.event = event
    
    let navController = PortraitNavController()
    navController.pushViewController(bluetoothVc, animated: false)
    
    viewController.present(navController, animated: true, completion: nil)
}

class BluetoothViewController: BaseVC<VcBluetoothLayout>, OnBluetoothConnectedListener {
    
    //MARK: properties
    var plan: Plan?
    var event: Event?
    
    //MARK: life cycle
    override func onResume() {
        refreshBluetoothList()
    }
    
    override func getContentLayout(contentView: UIView) -> VcBluetoothLayout {
        return VcBluetoothLayout(contentView: contentView, bluetoothVc: self, bluetoothConnectedListener: self)
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
        showCloseButton()
    }
    
    //MARK: functions
    func refreshBluetoothList() {
        contentLayout!.bluetoothList.refresh()
    }
    
    //MARK: protocol
    func onConnected() {
        showProgress(isShow: false)
        
        startTrainingViewController(vc: self, trainingEnvType: TrainingEnvironmentType.ergometer, plan: plan, event: event)
    }
    
    func onDisconnected() {
        refreshBluetoothList()
        showProgress(isShow: false)
    }
}
