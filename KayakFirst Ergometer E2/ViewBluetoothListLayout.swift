//
//  ViewBluetoothListLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewBluetoothListLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-margin2)
            make.top.equalToSuperview().offset(margin)
        }
        
        contentView.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(labelTitle.snp.bottom).offset(margin)
        }
        
        contentView.addSubview(bluetoothTableView)
        bluetoothTableView.snp.makeConstraints { (make) in
            make.top.equalTo(progressBar.snp.bottom).offset(margin)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: views
    lazy var labelTitle: UILabel! = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        label.text = getString("fragment_bluetooth_title")
        
        return label
    }()
    
    lazy var progressBar: AppProgressBar! = {
        let spinner = AppProgressBar()
        
        spinner.isHidden = true
        
        return spinner
    }()
    
    lazy var bluetoothTableView: BluetoothDeviceTableView! = {
        let view = BluetoothDeviceTableView(view: self.contentView)
        
        return view
    }()
    
}
