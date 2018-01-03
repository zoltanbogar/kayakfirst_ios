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
    
    private var realDuration: Int64 = 0
    private var isCyclePaused: Bool = false
    
    //MARK: init
    init(telemetry: Telemetry) {
        self.telemetry = telemetry
        trainingManager = TrainingManager.sharedInstance
        
        reset()
    }
    
    //MARK: abstract functions
    internal func getTelemetryObject() -> TelemetryObject {
        fatalError("must be implemented")
    }
    
    internal func getTelemetryAvgObject() -> TelemetryAvgObject {
        fatalError("must be implemented")
    }
    
    internal func resetServices() {
        fatalError("must be implemented")
    }
    
    //MARK: functions
    func bindService(isBind: Bool) {
        if isBind {
            SwiftEventBus.onBackgroundThread(self, name: cycleStateEventBusName, handler: { result in
                //TODO: nullcheck
                let cycleState: CycleState = result.object as! CycleState
                self.onCycleStateChanged(cycleState: cycleState)
            })
        } else {
            SwiftEventBus.unregister(self, name: cycleStateEventBusName)
        }
    }
    
    func start() {
        reset()
        resume()
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
    
    internal func shouldCalculate() -> Bool {
        return true
    }
    
    internal func getTimeWaitAfterCalculate() -> useconds_t {
        return 0
    }
    
    internal func onResumed() {
        //TODO
    }
    
    internal func onStopped() {
        //TODO
    }
    
    internal func onPaused() {
        isCyclePaused = true
    }
    
    private func reset() {
        realDuration = 0
        telemetry.resetCurrent()
        telemetry.resetOthers()
        
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
                    let telemetryObject = self.getTelemetryObject()
                    let telemetryAvgObject = self.getTelemetryAvgObject()
                    
                    self.telemetry.telemetryObject = telemetryObject
                    self.telemetry.telemetryAvgObject = telemetryAvgObject
                    
                    self.trainingManager.saveTrainingAvg(telemetryObject: telemetryObject, telemetryAvgObject: telemetryAvgObject)
                    
                    self.realDuration = Int64(self.telemetry.duration)
                }
                
                usleep(self.getTimeWaitAfterCalculate())
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
        //TODO
    }
    
    private func setDurationBack() {
        //TODO
    }
    
    private func onCycleStateChanged(cycleState: CycleState) {
        switch cycleState {
        case CycleState.resumed:
            onResumed()
        case CycleState.stopped:
            onStopped()
        case CycleState.paused:
            onPaused()
        default:
            //TODO: handle default
            let index = 0
        }
    }

}
