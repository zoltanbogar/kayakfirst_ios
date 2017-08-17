//
//  CalculateStrokes_AV_Outdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 15..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateStrokes_AV_Outdoor: CalculateStrokes_AV<MeasureCommand> {
    
    override func calculate() -> Double {
        let index: Double = Double(telemetry.averageIndex)
        
        if index > 0 && !getAvValue().isNaN && !getAvValue().isNaN {
            calculatedValue = ((getAvValue() * (index - 1)) + getActValue()) / index
        }
        
        return calculatedValue
    }
    
}
