//
//  CalculateElementVOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementVOutdoor: CalculateElementV<StartCommandOutdoor> {
    
    private var currentTimeStamp: Double = 0
    
    override func run() -> Training {
        calculatedValue = startCommand.speed
        
        return createTrainingObject()
    }
    
}
