//
//  PlanEtMinute.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanEtMinute: PlanEtSec {
    
    override func getType() -> PlanTextType {
        return PlanTextType.minute
    }
}
