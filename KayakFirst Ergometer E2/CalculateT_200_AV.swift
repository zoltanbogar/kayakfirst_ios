//
//  CalculateT_200_AV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateT_200_AV<M: MeasureCommand>: CalculateElementT_200<M> {
    
    override func getSpeed() -> Double {
        return startCommand.speedAv
    }
    
}
