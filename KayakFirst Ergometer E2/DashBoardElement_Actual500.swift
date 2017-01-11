//
//  DashBoardElement_Actual500.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Actual500: DashBoardElement {
    
    override internal func getTitle() -> String {
        return try! getString("dashboard_title_av_500")
    }
    
}
