//
//  MainVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class MainVc: MainTabVc {
    
    //MARK: views
    override func initView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
                
        stackView.addArrangedSubview(btnErgo)
        stackView.addHorizontalSeparator(color: Colors.colorDashBoardDivider, thickness: 1)
        stackView.addArrangedSubview(btnOutdoor)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.center.equalTo(contentView)
        }
    }
    
    private lazy var btnErgo: UIButton! = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "halfBulb"), for: .normal)
        
        button.addTarget(self, action: #selector(clickBtnErgo), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnOutdoor: UIButton! = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "halfSun"), for: .normal)
        
        button.addTarget(self, action: #selector(clickBtnOutdoor), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func clickBtnOutdoor() {
       startOutdoorViewController(viewController: self)
    }
    
    @objc private func clickBtnErgo() {
        startErgometerViewController(viewController: self)
    }
}
