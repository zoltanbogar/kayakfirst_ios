//
//  TrainingService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

class TrainingService: CycleStateChangeListener {
    
    //MARK: properties
    let telemetry = Telemetry.sharedInstance
    var commandList: [MeasureCommand]?
    var startCommand: StartCommand<MeasureCommand>?
    
    private let pauseDiff = PauseDiff.sharedInstance
    private var cycleIndex: Int64 = 0
    
    private let autoStopIdle = AutoStopIdle.sharedInstance
    private let autoStopStop = AutoStopStop.sharedInstance
    private let autoStopPause = AutoStopPause.sharedInstance
    private let autoStopResume = AutoStopResume.sharedInstance
    
    private let saveValues = SaveValues.sharedInstance
    
    private var realDuration: Double = 0
    
    //MARK: init
    internal init() {
        telemetry.addCycleStateChangeListener(cycleStateChangeListener: self)
    }
    
    //MARK: abstract methods
    internal func initCommandList() {
        fatalError("Must be implemented")
    }
    
    internal func initStartCommand() {
        fatalError("Must be implemented")
    }
    
    internal func runCommandList() {
        fatalError("Must be implemented")
    }
    
    internal func handleStartTraining() {
        fatalError("Must be implemented")
    }
    
    internal func handleStopTraining() {
        fatalError("Must be implemented")
    }
    
    internal func runCalculate() -> Bool {
        fatalError("Must be implemented")
    }
    
    internal func shouldWaitAfterCalculate() -> Bool {
        fatalError("Must be implemented")
    }
    
    func startService() {
        if isCycleState(cycleState: CycleState.quit) || isCycleState(cycleState: CycleState.permittionDenied) {
            setTelemetryCycleState(cycleState: CycleState.none)
        }
    }
    
    //MARK: lifecycle
    func startCycle() {
        if !isCycleState(cycleState: CycleState.paused) {
            reset()
            //TODO: alarm
        }
        pauseDiff.resume()
        setTelemetryCycleState(cycleState: CycleState.resumed)
    }
    
    func pauseCycle() {
        pauseDiff.pause()
        setTelemetryCycleState(cycleState: CycleState.paused)
    }
    
    func stopCycle() {
        setTelemetryCycleState(cycleState: CycleState.stopped)
    }
    
    func startDashboard() {
        setTelemetryCycleState(cycleState: CycleState.idle)
    }
    
    internal func reset() {
        initStartCommand()
        startCommand!.reset()
        
        initCommandList()
        
        autoStopIdle.reset()
        autoStopStop.reset()
        autoStopPause.reset()
        autoStopResume.reset()
        
        pauseDiff.reset()
        
        realDuration = 0
        cycleIndex = 0
        
        telemetry.resetCurrent()
        telemetry.resetOthers()
    }
    
    private func startLoop() {
        DispatchQueue.global().async {
            while !self.isCycleState(cycleState: CycleState.quit) && !self.isCycleState(cycleState: CycleState.permittionDenied) {
                var shouldWait = true
                if CLLocationManager.authorizationStatus() == .authorizedAlways {
                    if !self.isCycleState(cycleState: CycleState.none) {
                        if !self.isCycleState(cycleState: CycleState.idle) {
                            self.autoStopIdle.reset()
                            if !self.isCycleState(cycleState: CycleState.stopped) {
                                self.autoStopStop.reset()
                                if !self.isCycleState(cycleState: CycleState.paused) {
                                    self.autoStopPause.reset()
                                    self.setDuration()
                                    
                                    if self.runCalculate() {
                                        self.autoStopResume.reset()
                                        
                                        let telemetryObject = self.startCommand!.calculate(measureCommands: self.commandList!)
                                        let telemetryAvgObject = self.startCommand!.calculateAvg()
                                        
                                        self.telemetry.telemetryObject = telemetryObject
                                        self.telemetry.telemetryAvgObject = telemetryAvgObject
                                        
                                        self.saveValues.saveTrainingAvgData(telemetryObject: telemetryObject, telemetryAvgObject: telemetryAvgObject)
                                        
                                        self.realDuration = self.telemetry.duration
                                        
                                        shouldWait = self.shouldWaitAfterCalculate()
                                    } else {
                                        self.autoStopResume.checkAutoStop()
                                    }
                                } else {
                                    self.autoStopResume.reset()
                                    self.autoStopPause.checkAutoStop()
                                }
                            } else {
                                self.setDurationBack()
                                self.autoStopPause.reset()
                                self.autoStopStop.checkAutoStop()
                            }
                        } else {
                            self.autoStopStop.reset()
                            self.autoStopIdle.checkAutoStop()
                        }
                    }
                } else {
                    self.setTelemetryCycleState(cycleState: CycleState.permittionDenied)
                }
                if shouldWait {
                    usleep(200000)
                }
            }
        }
    }
    
    //TODO: not so seamless, it can 'stick'
    private func setDuration() {
        let timeDiff = pauseDiff.getAbsoluteTimeStamp() - telemetry.sessionId
        
        telemetry.duration = timeDiff
    }
    
    private func setDurationBack() {
        telemetry.duration = realDuration
    }
    
    internal func isCycleState(cycleState: CycleState) -> Bool {
        return cycleState == telemetry.cycleState
    }
    
    private func setTelemetryCycleState(cycleState: CycleState) {
        telemetry.cycleState = cycleState
    }
    
    internal func setCycleIndex(cycleIndex: Int64) {
        self.cycleIndex = pauseDiff.getAbsoluteCycleIndex(cycleIndex: cycleIndex)
    }
    
    func onCycleStateChanged(newCycleState: CycleState) {
        switch newCycleState {
        case CycleState.none:
            reset()
            startLoop()
            handleStartTraining()
        case CycleState.permittionDenied:
            handleStopTraining()
        case CycleState.stopped:
            telemetry.resetCurrent()
        case CycleState.quit:
            handleStopTraining()
        default:
            log("CYCLE_STATE", "newCycleState: \(newCycleState)")
        }
    }
    
}
