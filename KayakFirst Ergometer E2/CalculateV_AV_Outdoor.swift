//
//  CalculateV_AV_Outdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalculateV_AV_Outdoor: CalculateV_AV<MeasureCommand> {
    
    override func calculate() -> Double {
        let distance = telemetry.distance
        let duration = telemetry.duration
        
        if duration > 0 {
            calculatedValue = (distance / duration) * 1000 * converSationMpsKmph
        }
        
        startCommand.v_av = calculatedValue
        
        return calculatedValue
    }
    
}
