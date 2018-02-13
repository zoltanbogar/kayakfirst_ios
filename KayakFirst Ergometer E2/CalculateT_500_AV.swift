//
//  CalculateT_500_AV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateT_500_AV<M: MeasureCommand>: CalculateT_AV<M> {
    
    override func getDistance() -> Double {
        return 500
    }
    
}
