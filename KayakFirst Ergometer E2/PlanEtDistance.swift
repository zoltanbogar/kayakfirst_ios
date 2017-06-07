//
//  PlanEtDistance.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanEtDistance: PlanEditText {
    
    override func isTextValid(text: String) -> Bool {
        return true
    }
    
    override func getType() -> PlanTextType {
        return PlanTextType.distance
    }
    
}
