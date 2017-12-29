//
//  VcBluetoothLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 29..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcBluetoothLayout: BaseLayout {
    
    private let trainingViewController: TrainingViewController
    
    init(contentView: UIView, trainingViewController: TrainingViewController) {
        self.trainingViewController = trainingViewController
        
        super.init(contentView: contentView)
    }
    
    override func setView() {
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
            make.bottom.equalTo(btnSetting.snp.top).offset(-margin2)
        }
    }
    
    //MARK: views
    lazy var btnSetting: AppUIButton! = {
        let button = AppUIButton(width: 0, text: getString("fragment_bluetooth_button_refresh"), backgroundColor: Colors.colorAccent, textColor: Colors.colorPrimary)
        
        return button
    }()
    
    lazy var bluetoothList: BluetoothList! = {
        let bluetoothList = BluetoothList(trainingViewController: self.trainingViewController)
        
        bluetoothList.btnBluetooth = self.btnSetting
        
        return bluetoothList
    }()
    
}
