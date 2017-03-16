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
        let speed = startCommand.speed * converSationMpsKmph
        
        if speed <= 0{
            if currentTimeStamp == 0 {
                currentTimeStamp = startCommand.getCalculatedTimeStamp()
            }
            
            let diffTimeStamp = startCommand.getCalculatedTimeStamp() - currentTimeStamp
            
            if diffTimeStamp != 0 {
                calculatedValue = (startCommand.s.dataValue / diffTimeStamp / 1000) * converSationMpsKmph
            }
            
            currentTimeStamp = startCommand.getCalculatedTimeStamp()
        } else {
            calculatedValue = speed
        }
        
        return createTrainingObject()
    }
    
}
