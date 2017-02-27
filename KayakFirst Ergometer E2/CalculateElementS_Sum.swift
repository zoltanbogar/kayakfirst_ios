//
//  CalculateElementS_Sum.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementS_Sum: CalculateElementCurrent {
    
    override func getDataType() -> CalculateEnum {
        return CalculateEnum.S_SUM
    }
    
    override func run() -> Training {
        calculatedValue = telemetry.distance + startCommand.s.dataValue
        
        return createTrainingObject()
    }
    
}
