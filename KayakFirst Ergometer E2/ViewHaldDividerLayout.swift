//
//  ViewHaldDividerLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewHalfDividerLayout: BaseLayout {
    
    override func setView() {
        contentView.backgroundColor = Colors.colorPrimary
        let divider = UIView()
        divider.backgroundColor = Colors.colorDashBoardDivider
        
        contentView.addSubview(divider)
        divider.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(margin, 0, margin, 0))
        }
    }
    
}
