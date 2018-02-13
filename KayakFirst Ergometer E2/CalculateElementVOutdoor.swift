//
//  CalculateElementVOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementVOutdoor: CalculateElementV<MeasureCommand, CommandProcessorOutdoor> {
    
    override func run() -> Double {
        calculatedValue = startCommand.speed
        
        return calculatedValue
    }
}
