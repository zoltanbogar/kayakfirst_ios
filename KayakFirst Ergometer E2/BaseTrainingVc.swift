//
//  BaseTrainingVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseTrainingVc<E: BaseLayout>: BaseVC<E> {
    
    //MARK: functions
    func getTrainingVc() -> TrainingViewController {
        return navigationController as! TrainingViewController
    }
    
    func handleBluetoothMenu(barButtons: [UIBarButtonItem]) {
        var buttons = barButtons
        if getTrainingEnvType() == TrainingEnvironmentType.ergometer {
            buttons.append(bluetoothTabBarItem)
        }
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: true)
    }
    
    func getTrainingEnvType() -> TrainingEnvironmentType {
        return getTrainingVc().trainingEnvType
    }
    
    func showBluetoothDisconnectDialog() {
        getTrainingVc().showBluetoothDisconnectDialog()
    }
    
    //MARK: views
    lazy var bluetoothTabBarItem: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_bluetooth")?.maskWith(color: Colors.colorBluetooth).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        button.target = self
        button.action = #selector(showBluetoothDisconnectDialog)
        
        return button
    }()
    
}
