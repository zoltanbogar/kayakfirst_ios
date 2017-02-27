//
//  TrainingService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingService<CommandType: MeasureCommand>: CycleStateChangeListener {
    
    //MARK: properties
    let telemetry = Telemetry.sharedInstance
    var commandList: [CommandType]?
    var startCommand: StartCommand<CommandType>?
    
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
    
    internal func handleStopTraining() {
        fatalError("Must be implemented")
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
    
    internal func startTrainig() {
        setTelemetryCycleState(cycleState: CycleState.idle)
    }
    
    internal func stopTraining() {
        setTelemetryCycleState(cycleState: CycleState.none)
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
            while !self.isCycleState(cycleState: CycleState.none) {
                var shouldWait = true
                if !self.isCycleState(cycleState: CycleState.idle) {
                    self.autoStopIdle.reset()
                    if !self.isCycleState(cycleState: CycleState.stopped) {
                        self.autoStopStop.reset()
                        if !self.isCycleState(cycleState: CycleState.paused) {
                            self.autoStopPause.reset()
                            self.setDuration()
                            
                            if self.isNewCycle() {
                                self.autoStopResume.reset()
                                
                                let telemetryObject = self.startCommand!.calculate(measureCommands: self.commandList!)
                                let telemetryAvgObject = self.startCommand!.calculateAvg()
                                
                                self.telemetry.telemetryObject = telemetryObject
                                self.telemetry.telemetryAvgObject = telemetryAvgObject
                                
                                self.saveValues.saveTrainingAvgData(telemetryObject: telemetryObject, telemetryAvgObject: telemetryAvgObject)
                                
                                self.realDuration = self.telemetry.duration
                                
                                shouldWait = false
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
                if shouldWait {
                    usleep(200000)
                }
            }
        }
    }
    
    internal func isNewCycle() -> Bool {
        let telemetryCycleIndex = telemetry.cycleIndex
        
        runCommandList()
        
        if cycleIndex > telemetryCycleIndex {
            telemetry.cycleIndex = self.cycleIndex
            return true
        } else if telemetryCycleIndex == 0 {
            return true
        }
        return false
    }
    
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
    
    func onCycleStateChanged(newCycleState: CycleState) {
        switch newCycleState {
        case CycleState.idle:
            reset()
            startLoop()
        case CycleState.none:
            handleStopTraining()
        case CycleState.stopped:
            telemetry.resetCurrent()
        default:
            log("CYCLE_STATE", "newCycleState: \(newCycleState)")
        }
    }
    
}
