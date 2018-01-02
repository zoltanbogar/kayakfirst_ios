//
//  DashboardView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DashboardView: CustomUi<ViewDashboardLayout> {
    
    override func getContentLayout(contentView: UIView) -> ViewDashboardLayout {
        return ViewDashboardLayout(contentView: contentView)
    }
    
}
