//
//  BluetoothViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothViewController: BaseVC<VcBluetoothLayout> {
    
    //MARK: life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshBluetoothList()
    }
    
    //MARK: functions
    func refreshBluetoothList() {
        contentLayout!.bluetoothList.refresh()
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
    }
    
    override func getContentLayout(contentView: UIView) -> VcBluetoothLayout {
        return VcBluetoothLayout(contentView: contentView, trainingViewController: parent as! TrainingViewController)
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
        showCloseButton()
    }
}
