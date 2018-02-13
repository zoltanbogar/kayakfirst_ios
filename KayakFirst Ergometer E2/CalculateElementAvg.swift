//
//  CalculateElementAvg.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementAvg<M: MeasureCommand>: CalculateElement<M,  CommandProcessor<M>> {
    
    //MARK: abstract functions
    internal func getActValue() -> Double {
        fatalError("Must be implemented")
    }
    
    internal func getAvValue() -> Double {
        fatalError("Must be implemented")
    }
    
    override func run() -> Double {
        return calculate()
    }
    
    internal func calculate() -> Double {
        let index: Double = Double(telemetry.averageIndex)
        
        if index > 0 && !getAvValue().isNaN && !getAvValue().isNaN {
            calculatedValue = ((getAvValue() * (index - 1)) + getActValue()) / index
        }
        
        return calculatedValue
    }
}
