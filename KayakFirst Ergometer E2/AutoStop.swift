//
//  AutoStop.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class AutoStop {
    
    //MARK: properties
    private let telemetry = Telemetry.sharedInstance
    private var startTimeStamp: Double = 0
    
    //MARK: abstract methods
    internal func getAutoStopTime() -> Double {
        fatalError("Must be implemented")
    }
    internal func getShouldCycleState() -> CycleState {
        fatalError("Must be implemented")
    }
    
    func reset() {
        startTimeStamp = 0
    }
    
    func checkAutoStop() {
        if startTimeStamp == 0 {
            startTimeStamp = currentTimeMillis()
        }
        
        let timeDiff: Double = currentTimeMillis() - startTimeStamp
        
        if timeDiff > getAutoStopTime() {
            telemetry.cycleState = getShouldCycleState()
        }
    }
    
}
