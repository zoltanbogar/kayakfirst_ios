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
    private let fullLightTime: TimeInterval = 5 // 5 sec
    private let noneLightTime: TimeInterval = 8 // 8 sec
    
    //MARK: properties
    private let telemetry = Telemetry.sharedInstance
    private var timer: Timer?
    private let menuItem: UIBarButtonItem
    
    private var shouldActive = false
    
    //MARK: init
    init(menuItem: UIBarButtonItem) {
        self.menuItem = menuItem
        
        self.menuItem.target = self
        self.menuItem.action = #selector(push)
    }
    
    //MARK: functions
    func cycleResume() {
        if shouldActive {
            activate(isActivate: true)
        }
    }
    
    func cyclePause() {
        activate(isActivate: false)
    }
    
    func cycleStop() {
        activate(isActivate: false)
    }
    
    func onResume() {
        if shouldActive {
            activate(isActivate: true)
        }
    }
    
    func onPause() {
        activate(isActivate: false)
    }
    
    @objc private func push() {
        shouldActive = !shouldActive
        
        if shouldActive && telemetry.checkCycleState(cycleState: CycleState.resumed) {
            activate(isActivate: true)
        } else {
            activate(isActivate: false)
        }
    }
    
    private func activate(isActivate: Bool) {
        timer?.invalidate()
        
        if isActivate && telemetry.checkCycleState(cycleState: CycleState.resumed) {
            startTimerFull()
        } else {
            setBrightness(isFull: true)
        }
        
        colorizeMenuItem()
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
        WindowHelper.setBrightness(isFull: isFull)
    }
    
    private func startTimer(timeInterval: TimeInterval, selector: Selector) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: nil, repeats: false)
    }
    
    private func colorizeMenuItem() {
        var color = Colors.colorBatterySaverInactive
        
        if shouldActive {
            color = Colors.colorBatterySaverActive
        }
        
        menuItem.tintColor = color
    }
}
