//
//  CalculateElementSOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

class CalculateElementSOutdoor: CalculateElementS<StartCommandOutdoor> {
    
    override func run() -> Training {
        calculatedValue = startCommand.distanceSum
        
        return createTrainingObject()
    }
}
