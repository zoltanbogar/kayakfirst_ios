//
//  BluetoothViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothViewController: BaseVC<VcBluetoothLayout>, OnBluetoothConnectedListener {
    
    //MARK: properties
    var plan: Plan?
    var event: Event?
    
    //MARK: life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshBluetoothList()
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
    }
    
    override func getContentLayout(contentView: UIView) -> VcBluetoothLayout {
        return VcBluetoothLayout(contentView: contentView, trainingViewController: parent as! TrainingViewControllerOld)
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
        //TODO
        startTrainingViewController(vc: self, trainingEnvType: TrainingEnvironmentType.ergometer, plan: plan, event: event)
    }
    
    func onDisconnected() {
        //TODO
    }
}
