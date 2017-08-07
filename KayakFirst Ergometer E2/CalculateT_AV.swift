//
//  CalculateT_AV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 22..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateT_AV: CalculateElementAvg<MeasureCommand> {
    
    //MARK: abstract method
    func getDistance() -> Double {
        fatalError("Must be implemented")
    }
    
    override func calculate() -> Double {
        let distance = getDistance()
        var v = startCommand.v_av
        
        if v > 0 {
            v = v / converSationMpsKmph
            
            calculatedValue = distance / v
            
            calculatedValue = calculatedValue * 1000
        }
        
        return calculatedValue
    }
    
}
