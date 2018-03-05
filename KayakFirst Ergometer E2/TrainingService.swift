//
//  TrainingService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftEventBus

class TrainingService {
    
    //MARK: properties
    internal let telemetry: Telemetry
    
    private let trainingManager: TrainingManager
    
    private var sumTraining: SumTraining?
    private var trainingEnvType: TrainingEnvironmentType?
    private var plan: Plan?
    
    private var realDuration: Double = 0
    private var isCyclePaused: Bool = false
    
    //MARK: init
    internal init() {
        self.telemetry = Telemetry.sharedInstance
        trainingManager = TrainingManager.sharedInstance
        
        reset()
    }
    
    //MARK: abstract functions
    internal func getTrainingObject() -> Training {
        fatalError("must be implemented")
    }
    
    internal func getTrainingAvgObject() -> TrainingAvg {
        fatalError("must be implemented")
    }
    
    internal func updateSumTraining(sumTraining: SumTraining) -> SumTraining {
        fatalError("must be implemented")
    }
    
    internal func resetServices() {
        fatalError("must be implemented")
    }
    
    internal func shouldCalculate() -> Bool {
        fatalError("must be implemented")
    }
    
    //MARK: functions
    func bindService(isBind: Bool) {
        if isBind {
            SwiftEventBus.onBackgroundThread(self, name: cycleStateEventBusName, handler: { result in
                let cycleState: CycleState = result.object as! CycleState
                self.onCycleStateChanged(cycleState: cycleState)
            })
        } else {
            SwiftEventBus.unregister(self, name: cycleStateEventBusName)
        }
    }
    
    func idle() {
        reset()
        setTelemetryCycleState(cycleState: CycleState.idle)
    }
    
    func calibrate() {
        setTelemetryCycleState(cycleState: CycleState.calibrated)
    }
    
    func start(trainingEnvType: TrainingEnvironmentType, plan: Plan?) {
        reset()
        
        self.trainingEnvType = trainingEnvType
        self.plan = plan
        
        resume()
        
        LogManager.sharedInstance.checkSystemInfo()
    }
    
    func resume() {
        setTelemetryCycleState(cycleState: CycleState.resumed)
    }
    
    func pause() {
        setTelemetryCycleState(cycleState: CycleState.paused)
    }
    
    func stop() {
        setTelemetryCycleState(cycleState: CycleState.stopped)
    }
    
    func destroy() {
        stop()
        reset()
    }
    
    func getCalibrationDuration() -> Double {
        return 0
    }
    
    internal func onResumed() {
        isCyclePaused = false
        
        setSessionId()
        
        trainingManager.addTrainingUploadPointer()
        
        startLoop()
    }
    
    internal func onStopped() {
        telemetry.resetCurrent()
        setDurationBack()
        isCyclePaused = true
    }
    
    internal func onPaused() {
        isCyclePaused = true
    }
    
    private func reset() {
        realDuration = 0
        telemetry.resetCurrent()
        telemetry.resetOthers()
        
        plan = nil
        
        resetServices()
    }
    
    private func setTelemetryCycleState(cycleState: CycleState) {
        telemetry.cycleState = cycleState
    }
    
    private func startLoop() {
        startDuration()
        
        DispatchQueue.global().async {
            while self.telemetry.checkCycleState(cycleState: CycleState.resumed) {
                
                if self.shouldCalculate() {
                    let training = self.getTrainingObject()
                    let trainingAvg = self.getTrainingAvgObject()
                    self.sumTraining = self.updateSumTraining(sumTraining: self.sumTraining!)
                    
                    self.telemetry.telemetryObject = training
                    self.telemetry.telemetryAvgObject = trainingAvg
                    
                    self.trainingManager.saveTrainingData(training: training, trainingAvg: trainingAvg, sumTrainig: self.sumTraining!)
                    
                    self.realDuration = self.telemetry.duration
                }
                
                usleep(300000)
            }
        }
    }
    
    private func startDuration() {
        DispatchQueue.global().async {
            while !self.isCyclePaused {
                self.setDuration()
                
                usleep(UInt32(refreshMillis * 1000))
            }
        }
    }
    
    private func setDuration() {
        telemetry.duration = (telemetry.getAbsoluteTimestamp() - telemetry.sessionId)
    }
    
    private func setDurationBack() {
        telemetry.duration = realDuration
    }
    
    private func setSessionId() {
        if telemetry.sessionId == 0 {
            let sessionId = currentTimeMillis()
            LogManager.sharedInstance.logEvent(event: "setSessionId: \(sessionId)")
            
            telemetry.sessionId = sessionId
            
            var planTraining: PlanTraining? = nil
            
            if let plan = plan {
                planTraining = PlanTraining.createPlanTraining(plan: plan)
                planTraining?.sessionId = sessionId
                
                PlanManager.sharedInstance.savePlanTraining(planTraining: planTraining!)
            }
            
            sumTraining = createSumTraining(
                sessionId: sessionId,
                trainingEnvType: trainingEnvType!.rawValue,
                planTrainingId: planTraining != nil ? planTraining!.planId : "",
                planTrainingType: planTraining != nil ? planTraining!.type : nil)
        }
    }
    
    private func onCycleStateChanged(cycleState: CycleState) {
        switch cycleState {
        case CycleState.resumed:
            onResumed()
        case CycleState.stopped:
            onStopped()
        case CycleState.paused:
            onPaused()
        case CycleState.bluetoothDisconnected:
            onStopped()
        default: break
        }
    }

}
