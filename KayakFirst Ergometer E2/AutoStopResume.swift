//
//  AutoStopResume.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class AutoStopResume: AutoStop {
    
    //MAKR: contstants
    private let autoStopTime: Double = 20 * 1000
    
    //MARK: init
    static let sharedInstance = AutoStopResume()
    private override init() {
        //private empty constructor
    }
    
    override func getAutoStopTime() -> Double {
        return autoStopTime
    }
    
    override func getShouldCycleState() -> CycleState {
        return CycleState.stopped
    }
}
