//
//  BluetoothViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothViewController: BaseVC {
    
    //MARK: life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bluetoothList.refresh()
    }
    
    //MARK: init view
    override func initView() {
        contentView.addSubview(bluetoothList)
        contentView.addSubview(btnSetting)
        
        btnSetting.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-margin)
            make.width.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin2, 0, margin2))
            make.centerX.equalTo(contentView)
        }
        
        bluetoothList.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(btnSetting.snp.top).offset(margin2)
        }
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
        showCloseButton()
    }
    
    //MARK: views
    private lazy var btnSetting: AppUIButton! = {
        let button = AppUIButton(width: 0, text: getString("fragment_bluetooth_button_refresh"), backgroundColor: Colors.colorAccent, textColor: Colors.colorPrimary)
        
        return button
    }()
    
    private lazy var bluetoothList: BluetoothList! = {
        let trainingViewController = self.parent as! TrainingViewController
        
        let bluetoothList = BluetoothList(trainingViewController: trainingViewController)
        
        bluetoothList.btnBluetooth = self.btnSetting
        
        return bluetoothList
    }()
}
