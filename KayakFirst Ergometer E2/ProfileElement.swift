//
//  ProfileElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class ProfileElement: BaseProfileElement<ViewProfileElementLayout> {
    
    override func getContentLayout(contentView: UIView) -> ViewProfileElementLayout {
        return ViewProfileElementLayout(contentView: contentView)
    }
    
}
