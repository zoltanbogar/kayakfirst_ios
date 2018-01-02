//
//  HalfDivider.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class HalfDivider: CustomUi {
    
    override func getContentLayout(contentView: UIView) -> BaseLayout {
        return ViewHalfDividerLayout(contentView: contentView)
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: dashboardDividerWidth, height: 0)
        }
    }
    
}
