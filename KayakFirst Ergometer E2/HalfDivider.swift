//
//  HalfDivider.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class HalfDivider: CustomUi<ViewHalfDividerLayout> {
    
    override func getContentLayout(contentView: UIView) -> ViewHalfDividerLayout {
        return ViewHalfDividerLayout(contentView: contentView)
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: dashboardDividerWidth, height: 0)
        }
    }
    
}
