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
    
    //MARK: properties
    private let view = UIView()
    
    //MARK: init data
    override func initData(data: CBPeripheral?) {
        labelName.text = data?.name
    }
    
    //MARK: init view
    override func initView() -> UIView {
        view.addSubview(labelName)
        labelName.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin2)
            make.centerY.equalToSuperview()
        }
        
        return view
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
