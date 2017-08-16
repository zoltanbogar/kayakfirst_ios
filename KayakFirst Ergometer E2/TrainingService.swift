//
//  TrainingService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingService<M: MeasureCommand>: CycleStateChangeListener {
    
    //MARK: properties
    let telemetry = Telemetry.sharedInstance
    var commandList: [M]?
    var startCommand: StartCommand<M>?
    
    let pauseDiff = PauseDiff.sharedInstance
    
    private let trainingManager = TrainingManager.sharedInstance
    
    private var realDuration: Double = 0
    
    internal var isServiceStopped = false
    
    private var isCyclePaused = false
    
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
    
    internal func runCalculate() -> Bool {
        fatalError("Must be implemented")
    }
    
    //useconds
    internal func getTimeWaitAfterCalculate() -> useconds_t {
        fatalError("Must be implemented")
    }
    
    internal func setTelemetryListener(_ isSet: Bool) {
        if isSet {
            telemetry.trainingServiceCycleStateChangeListener = self
        } else {
            telemetry.trainingServiceCycleStateChangeListener = nil
        }
        isServiceStopped = !isSet
    }
    
    //MARK: lifecycle
    func startCycle() {
        if !isCycleState(cycleState: CycleState.paused) {
            reset()
        }
        pauseDiff.resume()
        setTelemetryCycleState(cycleState: CycleState.resumed)
        trainingManager.addTrainingUploadPointer()
    }
    
    func pauseCycle() {
        pauseDiff.pause()
        setTelemetryCycleState(cycleState: CycleState.paused)
    }
    
    func stopCycle() {
        setTelemetryCycleState(cycleState: CycleState.stopped)
    }
    
    internal func reset() {
        initStartCommand()
        startCommand!.reset()
        
        initCommandList()
        
        pauseDiff.reset()
        
        realDuration = 0
        
        telemetry.resetCurrent()
        telemetry.resetOthers()
    }
    
    private func startLoop() {
        startDuration()
        
        DispatchQueue.global().async {
            while self.telemetry.checkCycleState(cycleState: CycleState.resumed) {
                
                if self.runCalculate() {
                    let telemetryObject = self.startCommand!.calculate(measureCommands: self.commandList!)
                    let telemetryAvgObject = self.startCommand!.calculateAvg()
                    
                    self.telemetry.telemetryObject = telemetryObject
                    self.telemetry.telemetryAvgObject = telemetryAvgObject
                    
                    self.trainingManager.saveTrainingAvg(telemetryObject: telemetryObject, telemetryAvgObject: telemetryAvgObject)
                    
                    self.realDuration = self.telemetry.duration
                }
                
                usleep(self.getTimeWaitAfterCalculate())
            }
        }
    }
    
    private func startDuration() {
        DispatchQueue.global().async {
            while !self.isCyclePaused {
                self.setDuration()
                
                usleep(UInt32(RefreshView.refreshMillis * 1000))
            }
            
            self.setDurationBack()
        }
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
        if !isServiceStopped {
            switch newCycleState {
            case CycleState.resumed:
                isCyclePaused = false
                startLoop()
            case CycleState.idle:
                reset()
            case CycleState.stopped:
                telemetry.resetCurrent()
                handleStopTraining()
            case CycleState.paused:
                isCyclePaused = true
            default:
                break
            }
        }
    }
    
}
