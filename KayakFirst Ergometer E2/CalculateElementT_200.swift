//
//  CalculateElementT_200.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementT_200: CalculateElementT {
    
    override func getDataType() -> CalculateEnum {
        return CalculateEnum.T_200
    }
    
    override func getDistance() -> Double {
        return 200
    }
}
