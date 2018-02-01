//
//  BaseTrainingVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseTrainingVc<E: BaseLayout>: BaseVC<E> {
    
    //MARK: lifecycle
    override func onResume() {
        getTrainingVc().onResume()
    }
    
    override func onPause() {
        getTrainingVc().onPause()
    }
    
    //MARK: functions
    func getTrainingVc() -> TrainingViewController {
        return navigationController as! TrainingViewController
    }
    
    func handleBluetoothMenu(barButtons: [UIBarButtonItem]?, badGpsTabBarItem: UIBarButtonItem?) {
        var buttons = barButtons
        if getTrainingEnvType() == TrainingEnvironmentType.ergometer {
            if buttons == nil {
                buttons = [UIBarButtonItem]()
            }
            buttons!.append(bluetoothTabBarItem)
        } else {
            if let badGpsTabBarItem = badGpsTabBarItem {
                if buttons == nil {
                    buttons = [UIBarButtonItem]()
                }
                buttons!.append(badGpsTabBarItem)
            }
        }
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: true)
    }
    
    func getTrainingEnvType() -> TrainingEnvironmentType {
        return getTrainingVc().trainingEnvType
    }
    
    override func btnCloseClick() {
        if getTrainingEnvType() == TrainingEnvironmentType.ergometer {
            showBluetoothDisconnectDialog()
        } else {
            getTrainingVc().finish()
        }
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
