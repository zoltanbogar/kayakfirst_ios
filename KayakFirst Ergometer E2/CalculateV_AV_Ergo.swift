//
//  CalculateV_AV_Ergo.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateV_AV_Ergo: CalculateV_AV<MeasureCommandErgometer> {
    
    override func calculate() -> Double {
        super.calculate()
        
        startCommand.speedAv = calculatedValue
        
        return calculatedValue
    }
}
