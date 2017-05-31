//
//  BatterySaveHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BatterySaveHelper {
    
    //MARK: constants
    private let fullLightTime: TimeInterval = 3 //3sec
    private let noneLightTime: TimeInterval = 8 //8sec
    
    //MARK: properties
    private let telemetry = Telemetry.sharedInstance
    private var timer: Timer?
    
    //MARK: functions
    public func activate(isActivate: Bool) {
        timer?.invalidate()
        
        if isActivate && telemetry.checkCycleState(cycleState: CycleState.resumed) {
            startTimerFull()
        } else {
            setBrightness(isFull: true)
        }
    }
    
    private func startTimerFull() {
        setBrightness(isFull: true)
        startTimer(timeInterval: fullLightTime, selector: #selector(tickTimerFull))
    }
    
    private func startTimerNone() {
        setBrightness(isFull: false)
        startTimer(timeInterval: noneLightTime, selector: #selector(tickTimerNone))
    }
    
    @objc private func tickTimerFull() {
        startTimerNone()
    }
    
    @objc private func tickTimerNone() {
        startTimerFull()
    }
    
    private func setBrightness(isFull: Bool) {
        UIScreen.main.brightness = isFull ? CGFloat(1) : CGFloat(0)
    }
    
    private func startTimer(timeInterval: TimeInterval, selector: Selector) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: nil, repeats: false)
    }
}
