//
//  PlanEtSec.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanEtSec: PlanEditText {
    
    override func isTextValid(text: String) -> Bool {
        if "" == text {
            return true
        }
        if text.characters.count > 2 {
            return false
        }
        let textInt: Int = Int(text)!
        
        return textInt <= 59
    }
    
    override func getType() -> PlanTextType {
        return PlanTextType.sec
    }
}
