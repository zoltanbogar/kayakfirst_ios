//
//  CalculateElementFOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CalculateElementFOutdoor: CalculateElementF<MeasureCommand, StartCommandOutdoor> {
    
    override func run() -> Training {
        return createTrainingObject()
    }
    
}
