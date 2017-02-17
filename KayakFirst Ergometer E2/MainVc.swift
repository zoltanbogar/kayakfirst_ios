//
//  MainVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class MainVc: BaseMainTabVC {
    
    //MARK: views
    override func initView() {
        contentView.addSubview(btnOutdoor)
        btnOutdoor.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
    
    private lazy var btnOutdoor: UIButton! = {
        let button = UIButton()
        
        button.setTitle("Outdoor", for: .normal)
        
        button.addTarget(self, action: #selector(clickBtnOutdoor), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func clickBtnOutdoor() {
        
    }
}
