//
//  PlanEtIntensity.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanEtIntensity: PlanEditText {
    
    override func isTextValid(text: String) -> Bool {
        return text.characters.count <= 2 || "100" == text
    }
    
    override func getType() -> PlanTextType {
        return PlanTextType.intensity
    }
}
