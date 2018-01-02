//
//  ViewAppToastLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewAppToastLayout: BaseLayout {
    
    override func setView() {
        contentView.backgroundColor = Colors.colorAccent
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(margin05, margin05, margin05, margin05))
        }
    }
    
    lazy var label: UILabel! = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        return label
    }()
    
}
