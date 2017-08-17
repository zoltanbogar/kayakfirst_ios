//
//  CalculateStrokes_AV.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
//abstract class
class CalculateStrokes_AV<M: MeasureCommand>: CalculateElementAvg<M> {
    
    override func getAvgType() -> CalculateEnum {
        return CalculateEnum.STROKES_AV
    }
    
    override func getActValue() -> Double {
        return telemetry.strokes
    }
    
    override func getAvValue() -> Double {
        return telemetry.strokes_av
    }
    
    override func calculate() -> Double {
        fatalError("must be implemented")
    }
}
