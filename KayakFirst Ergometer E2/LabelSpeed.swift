//
//  LabelSpeed.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class LabelSpeed: DiagramLabel {
    override func getLabel() -> CalculateEnum {
        return CalculateEnum.V
    }
}
