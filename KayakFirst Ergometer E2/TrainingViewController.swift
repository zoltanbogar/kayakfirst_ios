//
//  TrainingViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftEventBus

func startTrainingViewController(vc: UIViewController, trainingEnvType: TrainingEnvironmentType, plan: Plan?, event: Event?) {
    
    let trainingVc = TrainingViewController()
    trainingVc.trainingEnvType = trainingEnvType
    trainingVc.plan = plan
    trainingVc.event = event
    
    vc.present(trainingVc, animated: true, completion: nil)
}

class TrainingViewController: PortraitNavController, CalibrationDelegate, StartDelayDelegate, PauseViewDelegate {
    
    //MARK: properties
    var trainingEnvType: TrainingEnvironmentType!
    
    var plan: Plan?
    var event: Event?
    
    private var dashboardVc: DashboardVc?
    
    private var telemetry = Telemetry.sharedInstance
    private var bluetooth = Bluetooth.sharedInstance
    private var trainingService: TrainingService!
    
    private var calibrationView: CalibrationView?
    private var startDelayView: StartDelayView!
    private var pauseView: PauseView!
    
    private var sessionId: Double = 0
    
    private var shouldCloseParents = false
    
    //MARK: lifecycle
    override func viewDidLoad() {
        switch trainingEnvType! {
        case TrainingEnvironmentType.ergometer:
            trainingService = ErgometerService(telemetry: telemetry, bluetooth: bluetooth)
        case TrainingEnvironmentType.outdoor:
            trainingService = OutdoorSevice(telemetry: telemetry)
        }
        
        trainingService.bindService(isBind: true)
        registerEventBus(isRegister: true)
        
        super.viewDidLoad()
        
        initView()
        
        //TODO
        pushViewController(SetDashboardVc(), animated: true)
    }
    
    //MARK: views
    private func initView() {
        startDelayView = StartDelayView(superView: view)
        startDelayView.delegate = self
        
        pauseView = PauseView(superView: view)
        pauseView.delegate = self
        
        addCalibrationViewIfNeeded()
    }
    
    private func addCalibrationViewIfNeeded() {
        if trainingEnvType == TrainingEnvironmentType.outdoor {
            calibrationView = CalibrationView(superView: view)
            calibrationView!.delegate = self
        }
    }
    
    func finish() {
        trainingService.bindService(isBind: false)
        registerEventBus(isRegister: false)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: public functions
    func showBluetoothDisconnectDialog() {
        BluetoothDisconnectDialog(bluetooth: bluetooth).show()
    }
    
    //TODO: should everytime create a new one? (Android too)
    func showDashboardVc(dashboardLayoutDict: [Int:Int]) {
        dashboardVc = DashboardVc()
        dashboardVc!.dashboardLayoutDict = dashboardLayoutDict
        pushViewController(dashboardVc!, animated: true)
    }
    
    func playClick() {
        switch trainingEnvType! {
        case TrainingEnvironmentType.outdoor:
            calibrationView?.showView()
        case TrainingEnvironmentType.ergometer:
            onCalibrationEnd()
        }
    }
    
    func pauseClick() {
        trainingService.pause()
    }
    
    //MARK: delegate
    func onResumeClicked() {
        trainingService.resume()
    }
    
    func onStopClicked() {
        trainingService.stop()
    }
    
    func onCalibrationEnd() {
        startDelayView.startCounter()
    }
    
    func onCounterEnd() {
        //TODO: reset plan
        trainingService.start()
    }
    
    //MARK: private functions
    private func registerEventBus(isRegister: Bool) {
        if isRegister {
            SwiftEventBus.onMainThread(self, name: cycleStateEventBusName, handler: { result in
                //TODO: nullcheck
                let cycleState: CycleState = result.object as! CycleState
                self.onCycleStateChanged(cycleState: cycleState)
            })
        } else {
            SwiftEventBus.unregister(self, name: cycleStateEventBusName)
        }
    }
    
    private func onCycleStateChanged(cycleState: CycleState) {
        switch cycleState {
        case CycleState.bluetoothDisconnected:
            finish()
        case CycleState.stopped:
            savePlan()
            setLayoutByCycleState(cycleState: cycleState)
        case CycleState.paused:
            setLayoutByCycleState(cycleState: cycleState)
        case CycleState.resumed:
            sessionId = telemetry.sessionId
            setLayoutByCycleState(cycleState: cycleState)
        default: break
        }
    }
    
    private func setLayoutByCycleState(cycleState: CycleState) {
        shouldCloseParents = false
        switch cycleState {
        case CycleState.resumed:
            //TODO: battery, plansound
            dashboardVc?.showViewSwipePause(isShow: true)
            dashboardVc?.initBtnPlaySmall(showRestart: false, isShow: false)
            dashboardVc?.refreshDashboardElements(true)
            showCloseButton(isShow: false)
        case CycleState.paused:
            pauseView.showPauseView()
            dashboardVc?.showViewSwipePause(isShow: false)
            dashboardVc?.initBtnPlaySmall(showRestart: true, isShow: false)
            dashboardVc?.refreshDashboardElements(false)
        case CycleState.stopped:
            dashboardVc?.showViewSwipePause(isShow: false)
            dashboardVc?.initBtnPlaySmall(showRestart: true, isShow: true)
            showCloseButton(isShow: true)
        default: break
        }
    }
    
    private func savePlan() {
        //TODO
    }
    
    private func showCloseButton(isShow: Bool) {
        if isShow {
            dashboardVc?.showCloseButton()
        } else {
            dashboardVc?.removeCloseButton()
        }
    }
    
}
