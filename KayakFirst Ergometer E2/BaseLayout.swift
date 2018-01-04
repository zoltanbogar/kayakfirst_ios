//
//  BaseLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseLayout {
    
    internal let contentView: UIView
    
    var isLandscape = false
    
    init(contentView: UIView) {
        self.contentView = contentView
    }
    
    func setView() {
        fatalError("must be implemented")
    }
    
    func handlePortraitLayout(size: CGSize) {
        isLandscape = false
    }
    
    func handleLandscapeLayout(size: CGSize) {
        isLandscape = true
    }
    
}
