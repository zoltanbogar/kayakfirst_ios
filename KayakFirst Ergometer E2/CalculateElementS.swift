//
//  CalculateElementS.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementS<M: MeasureCommand, E: CommandProcessor<M>>: CalculateElement<Training, M, E> {
    
    override func getDataType() -> CalculateEnum {
        return CalculateEnum.S
    }
}
