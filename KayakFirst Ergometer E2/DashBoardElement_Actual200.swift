//
//  DashBoardElement_Actual200.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class DashBoardElement_Actual200: DashBoardElement {
    
    override internal func getTitle() -> String {
        return try! getString("dashboard_title_av_200")
    }
    
}
