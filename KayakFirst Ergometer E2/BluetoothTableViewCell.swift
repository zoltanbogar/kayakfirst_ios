//
//  BluetoothTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothTableViewCell: AppUITableViewCell<CBPeripheral> {
    
    //MARK: init data
    override func initData(data: CBPeripheral?) {
        //TODO
        
        labelName.text = data?.name
    }
    
    //MARK: init view
    override func initView() -> UIView {
        return labelName
    }
    
    override func getRowHeight() -> CGFloat {
        return trainingRowHeight
    }
    
    //MARK: views
    private lazy var labelName: UILabel! = {
        let label = UILabel()
        
        return label
    }()
}
