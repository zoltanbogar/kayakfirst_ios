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
    internal func getDistance() -> Double {
        fatalError("Must be implemented")
    }
    
    override func run() -> Training {
        let distance = getDistance()
        var v = startCommand.v.dataValue
        
        if v > Double(minSpeedKmh) {
            v = v / converSationMpsKmph
            
            calculatedValue = distance / v
            
            calculatedValue = calculatedValue * 1000
        }
        return createTrainingObject()
    }
}
