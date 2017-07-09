//
//  Telemetry.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class Telemetry {
    
    //MARK: init
    static let sharedInstance: Telemetry = Telemetry()
    private init() {
        //private constructor
    }
    
    //MARK? current values
    var force: Double = 0
    var speed: Double = 0
    var distance: Double = 0
    var strokes: Double = 0
    var t_200: Double = 0
    var t_500: Double = 0
    var t_1000: Double = 0
    
    //MARK: average values
    var force_av: Double = 0
    var speed_av: Double = 0
    var strokes_av: Double = 0
    var t_200_av: Double = 0
    var t_500_av: Double = 0
    var t_1000_av: Double = 0
    
    //MARK: helper values
    var duration: TimeInterval = 0
    var cycleIndex: Int64 = 0
    var averageIndex: Int64 = 0
    var sessionId: Double = 0
    
    //MARK telemtry objects
    var telemetryObject: TelemetryObject? {
        didSet {
            force = telemetryObject!.f.dataValue
            speed = telemetryObject!.v.dataValue
            distance = telemetryObject!.s_sum.dataValue
            strokes = telemetryObject!.strokes.dataValue
            t_200 = telemetryObject!.t200.dataValue
            t_500 = telemetryObject!.t500.dataValue
            t_1000 = telemetryObject!.t1000.dataValue
            
            setAverageIndex()
        }
    }
    
    var telemetryAvgObject: TelemetryAvgObject? {
        didSet {
            force_av = telemetryAvgObject!.f_av.avgValue
            speed_av = telemetryAvgObject!.v_av.avgValue
            strokes_av = telemetryAvgObject!.strokes_av.avgValue
            t_200_av = telemetryAvgObject!.t_200_av.avgValue
            t_500_av = telemetryAvgObject!.t_500_av.avgValue
            t_1000_av = telemetryAvgObject!.t_1000_av.avgValue
        }
    }
    
    //MARK: cycle state
    var cycleState: CycleState? {
        didSet {
            if cycleState == CycleState.resumed {
                if sessionId == 0 {
                    sessionId = currentTimeMillis()
                }
            }
            
            if let cycleStateListeners = cycleStateChangeListenerList {
                if cycleState != nil {
                    for listener in cycleStateListeners {
                        listener.onCycleStateChanged(newCycleState: cycleState!)
                    }
                }
            }
        }
    }
    
    //MARK: other properties
    private var cycleStateChangeListenerList: [CycleStateChangeListener]?
    
    func addCycleStateChangeListener(cycleStateChangeListener: CycleStateChangeListener) {
        if self.cycleStateChangeListenerList == nil {
            self.cycleStateChangeListenerList = [CycleStateChangeListener]()
        }
        self.cycleStateChangeListenerList?.append(cycleStateChangeListener)
    }
    
    private func setAverageIndex() {
        if averageIndex == 0 {
            if speed > 0 {
                averageIndex = averageIndex + 1
            }
        } else {
            averageIndex = averageIndex + 1
        }
    }
    
    //MARK: reset
    func resetCurrent() {
        force = 0
        speed = 0
        strokes = 0
        t_200 = 0
        t_500 = 0
        t_1000 = 0
        
        sessionId = 0
    }
    
    func resetOthers() {
        distance = 0
        force_av = 0
        speed_av = 0
        strokes_av = 0
        t_200_av = 0
        t_500_av = 0
        t_1000_av = 0
        
        duration = 0
        averageIndex = 0
        cycleIndex = 0
    }
    
    //MARK other functions
    func checkCycleState(cycleState: CycleState) -> Bool {
        var isSame = false
        if let selfCycleState = self.cycleState {
            isSame = selfCycleState == cycleState
        }
        return isSame
    }
}

//MARK: protocol
public protocol CycleStateChangeListener {
    func onCycleStateChanged(newCycleState: CycleState)
}
