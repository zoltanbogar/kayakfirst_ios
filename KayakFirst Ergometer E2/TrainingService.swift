//
//  TrainingService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingService: CycleStateChangeListener {
    
    //MARK: properties
    let telemetry = Telemetry.sharedInstance
    var commandList: [MeasureCommand]?
    var startCommand: StartCommand<MeasureCommand>?
    
    private let pauseDiff = PauseDiff.sharedInstance
    
    private let trainingManager = TrainingManager.sharedInstance
    
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
    
    internal func runCalculate() -> Bool {
        fatalError("Must be implemented")
    }
    
    //useconds
    internal func getTimeWaitAfterCalculate() -> useconds_t {
        fatalError("Must be implemented")
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
            while self.telemetry.checkCycleState(cycleState: CycleState.resumed) {
                self.setDuration()
            }
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
        switch newCycleState {
        case CycleState.resumed:
            startLoop()
        case CycleState.idle:
            reset()
        case CycleState.stopped:
            setDurationBack()
            telemetry.resetCurrent()
            handleStopTraining()
        default:
            log("CYCLE_STATE", "newCycleState: \(newCycleState)")
        }
    }
    
}
