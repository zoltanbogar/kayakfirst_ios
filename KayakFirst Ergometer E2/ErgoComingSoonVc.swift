//
//  ErgoComingSoonVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class ErgoComingSoonVc: BaseVC {
    
    //MARK: init view
    override func initView() {
        contentView.addSubview(labelTitle)
        contentView.addSubview(imgBulb)
    }
    
    override func handlePortraitLayout(size: CGSize) {
        labelTitle.snp.removeConstraints()
        imgBulb.snp.removeConstraints()
        labelTitle.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(2 * margin2, 0, 0, 0))
        }
        imgBulb.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 2 * margin2, 0))
        }
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        labelTitle.snp.removeConstraints()
        imgBulb.snp.removeConstraints()
        labelTitle.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(margin, 0, 0, 0))
        }
        imgBulb.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoOnRight()
    }
    
    //MARK: views
    private lazy var labelTitle: UILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        
        label.text = getString("ergometer_placeholder")
        
        return label
    }()
    
    private lazy var imgBulb: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "blurredBulb")
        
        imageView.image = image
        
        return imageView
    }()
}
