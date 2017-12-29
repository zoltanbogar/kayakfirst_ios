//
//  VcLocationPermissionLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 29..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcLocationPermissionLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(imgLocationIcon)
        contentView.addSubview(label)
        contentView.addSubview(btnSetting)
        
        imgLocationIcon.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imgLocationIcon.snp.bottom).offset(margin)
            make.centerX.equalTo(contentView)
            make.width.equalTo(contentView)
        }
        btnSetting.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-margin)
            make.width.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin2, 0, margin2))
            make.centerX.equalTo(contentView)
        }
    }
    
    //MARK: views
    lazy var imgLocationIcon: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_location_on_white_48pt")!, color: Colors.colorAccent)
        
        return button
    }()
    
    lazy var label: UILabel! = {
        let label = AppUILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = getString("permission_location_ios")
        
        return label
    }()
    
    lazy var btnSetting: AppUIButton! = {
        let button = AppUIButton(width: 0, text: getString("fragment_bluetooth_app_details_settings"), backgroundColor: Colors.colorAccent, textColor: Colors.colorPrimary)
        
        return button
    }()
    
}
