//
//  CalculateElementT.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementT<M: MeasureCommand>: CalculateElementCurrent<M> {
    
    //MARK: abstract method
    internal func getDistance() -> Pace {
        fatalError("Must be implemented")
    }
    
    override func run() -> Double {
        let distance = Double(getDistance().rawValue)
        var v = startCommand.speed
        
        if v > Double(minSpeedKmh) {
            v = v / converSationMpsKmph
            
            calculatedValue = distance / v
            
            calculatedValue = calculatedValue * 1000
        }
        return calculatedValue
    }
}
