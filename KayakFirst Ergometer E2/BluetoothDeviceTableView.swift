//
//  BluetoothDeviceTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothDeviceTableView: TableViewWithEmpty<CBPeripheral> {
    
    //MARK: properties
    private let emptyView = UIView()
    
    //MARK: properties
    var emptyText: String? {
        didSet {
            labelEmpty.text = emptyText
        }
    }
    
    //MARK: override abstract functions
    override func getEmptyView() -> UIView {
        emptyView.addSubview(labelEmpty)
        labelEmpty.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
        return emptyView
    }
    
    override func getCellClass() -> AnyClass {
        return BluetoothTableViewCell.self
    }
    
    override func getHeaderView() -> AppTableViewHeader? {
        return nil
    }
    
    //MARK: views
    private lazy var labelEmpty: UILabel! = {
        let label = AppUILabel()
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
}
