//
//  PlanManagerType.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 20..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum PlanManagerType: Int, BaseManagerType {
    case upload = 0
    case download_plan_days = 1
    case delete = 2
    case edit = 3
    case download_plan = 4
    
    func isProgressShown() -> Bool {
        return self.rawValue > PlanManagerType.download_plan_days.rawValue
    }
}
