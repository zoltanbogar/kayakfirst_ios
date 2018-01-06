//
//  CalculateElementT_500.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementT_500<M: MeasureCommand>: CalculateElementT<M> {
    
    override func getDataType() -> CalculateEnum {
        return CalculateEnum.T_500
    }
    
    override func getDistance() -> Pace {
        return Pace.pace500
    }
}
