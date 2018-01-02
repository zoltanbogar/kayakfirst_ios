//
//  Divider.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DividerView: CustomUi {
    
    override func getContentLayout(contentView: UIView) -> BaseLayout {
        return ViewDividerLayout(contentView: contentView)
    }
    
}
