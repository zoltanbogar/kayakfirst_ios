//
//  ErgoComingSoonVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class ErgoComingSoonVc: BaseVC {
    
    override func initView() {
        contentView.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
        }
    }
    
    override func initTabBarItems() {
        self.navigationItem.setLeftBarButtonItems([btnClose], animated: true)
    }
    
    private lazy var labelTitle: UILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        
        label.text = getString("ergometer_placeholder")
        
        return label
    }()
    
    //MARK: tabbarItems
    private lazy var btnClose: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_clear_white_24dp")
        button.target = self
        button.action = #selector(btnCloseClick)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func btnCloseClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
