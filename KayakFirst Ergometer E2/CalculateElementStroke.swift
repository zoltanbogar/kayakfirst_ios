//
//  CalculateElementStroke.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementStroke<E: StartCommand<MeasureCommand>>: CalculateElement<Training, E> {
    
    override func getDataType() -> CalculateEnum {
        return CalculateEnum.STROKES
    }
    
}
