//
//  CalculateElementT_200.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementT_200<M: MeasureCommand>: CalculateElementCurrent<M> {
    
    /**
     * if speed less than the CalculateElement.minSpeed the pace value would be extreme high
     * in this situation we use the previous value
     */
    override func run() -> Double {
        let distance = Double(Pace.pace200.rawValue)
        var v = getSpeed()
        
        if v > Double(minSpeedKmh) {
            v = v / converSationMpsKmph
            
            calculatedValue = distance / v
            
            calculatedValue = calculatedValue * 1000
        }
        return calculatedValue
    }
    
    func getSpeed() -> Double {
        return startCommand.speed
    }
}
