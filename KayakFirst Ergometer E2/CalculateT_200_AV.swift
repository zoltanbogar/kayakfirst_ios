//
//  CalculateT_200_AV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateT_200_AV: CalculateT_AV {
    
    override func getAvgType() -> CalculateEnum {
        return CalculateEnum.T_200_AV
    }
    
    override func getDistance() -> Double {
        return 200
    }
    
}
