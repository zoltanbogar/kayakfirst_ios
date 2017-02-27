//
//  PauseDiff.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class PauseDiff {
    
    //MARK: properties
    private let telemetry = Telemetry.sharedInstance
    
    private var timeStampDiff: Double = 0
    private var cycleIndexDiff: Int64 = 0
    
    private var pauseTimeStamp: Double = 0
    private var pauseCycleIndex: Int64 = 0
    
    private var wasPause = false
    
    //MARK: init
    static let sharedInstance: PauseDiff = PauseDiff()
    private init() {
        //private empty constructor
    }
    
    func reset() {
        timeStampDiff = 0
        cycleIndexDiff = 0
        pauseTimeStamp = 0
        pauseCycleIndex = 0
        wasPause = false
    }
    
    func pause() {
        pauseTimeStamp = currentTimeMillis()
        pauseCycleIndex = telemetry.cycleIndex
        wasPause = true
    }
    
    func resume() {
        if pauseTimeStamp != 0 {
            timeStampDiff = timeStampDiff + currentTimeMillis() - pauseTimeStamp
        }
    }
    
    func getAbsoluteTimeStamp() -> Double {
        return currentTimeMillis() - timeStampDiff
    }
    
    func getAbsoluteCycleIndex(cycleIndex: Int64) -> Int64 {
        if wasPause {
            cycleIndexDiff = cycleIndex - pauseCycleIndex
            wasPause = false
        }
        return cycleIndex - cycleIndexDiff
    }
    
    
}