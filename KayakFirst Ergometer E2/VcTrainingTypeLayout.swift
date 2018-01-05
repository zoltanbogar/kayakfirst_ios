//
//  VcMainLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 28..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcTrainingTypeLayout: BaseLayout {
    
    override func setView() {
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
    
    lazy var btnErgo: UIButton! = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "halfBulb"), for: .normal)
        
        return button
    }()
    
    lazy var btnOutdoor: UIButton! = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "halfSun"), for: .normal)
        
        return button
    }()
    
}
