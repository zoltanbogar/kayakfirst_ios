//
//  MovingAverage.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class MovingAverage {
    
    //MARK: properties
    var numAverage: Double = 3
    private var values: [Double]
    
    //MARK: init
    init() {
        values = [Double]()
    }
    
    func calAverage(newValue: Double) -> Double {
        var size: Double = Double(values.count)
        if size > numAverage {
            values.remove(at: 0)
        }
        
        if size > 0 || newValue != 0 {
            values.append(newValue)
        }
        
        size = Double(values.count)
        
        var sumValue: Double = 0
        for d in values {
            sumValue += d
        }
        
        var average: Double = 0
        
        if size > 0 {
            average = sumValue / size
        }
        
        return average
    }
}
