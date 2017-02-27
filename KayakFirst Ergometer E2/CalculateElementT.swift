//
//  CalculateElementT.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementT: CalculateElementCurrent {
    
    //MARK: abstract method
    internal func getDistance() -> Double {
        fatalError("Must be implemented")
    }
    
}
