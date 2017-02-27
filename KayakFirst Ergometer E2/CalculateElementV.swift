//
//  CalculateElementV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

//TODO: mo to the CalculateElement constants
let converSationMpsKmph: Double = 3.6
let maxSpeedKmph: Double = 30

class CalculateElementV<E: StartCommand<MeasureCommand>>: CalculateElement<Training, E> {
    
    override func getDataType() -> CalculateEnum {
        return CalculateEnum.V
    }
}
