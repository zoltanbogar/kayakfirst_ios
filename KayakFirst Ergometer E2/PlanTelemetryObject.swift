//
//  PlanTelemetryObject.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 19..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

struct PlanTelemetryObject {
    
    let planElementColor: UIColor
    let planElementList: [PlanElement]?
    let value: Double
    let valueAccent: Double
    let totalProgress: Double
    let actualProgress: Double
    let isDone: Bool
    
}
