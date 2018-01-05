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

class TrainingViewController: PortraitNavController, StartDelayDelegate, PauseViewDelegate {
    
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
    
    private var batterySaveHelper: BatterySaveHelper?
    var planSoundHelper: PlanSoundHelper?
    
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
        
        checkPlanLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keepScreenOn(isOn: true)
        
        batterySaveHelper?.onResume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keepScreenOn(isOn: false)
        
        batterySaveHelper?.onPause()
    }
    
    //MARK: views
    private func initView() {
        startDelayView = StartDelayView(superView: view)
        startDelayView.delegate = self
        
        pauseView = PauseView(superView: view)
        pauseView.delegate = self
        
        calibrationView = CalibrationView(superView: view)
    }
    
    //MARK: public functions
    func initBatterySaveHelper() {
        batterySaveHelper = BatterySaveHelper(menuItem: dashboardVc!.contentLayout!.btnPowerSaveOff)
    }
    
    func finish() {
        trainingService.bindService(isBind: false)
        registerEventBus(isRegister: false)
        dismiss(animated: true, completion: nil)
    }
    
    func showBluetoothDisconnectDialog() {
        BluetoothDisconnectDialog(bluetooth: bluetooth).show()
    }
    
    //TODO: should everytime create a new one? (Android too)
    func showDashboardVc(dashboardLayoutDict: [Int:Int]) {
        dashboardVc = DashboardVc()
        dashboardVc!.dashboardLayoutDict = dashboardLayoutDict
        pushViewController(dashboardVc!, animated: true)
    }
    
    func checkPlanLayout() {
        if plan != nil {
            dashboardVc = DashboardVc()
            dashboardVc?.plan = plan
            pushViewController(dashboardVc!, animated: true)
        } else {
            pushViewController(SetDashboardVc(), animated: true)
        }
    }
    
    func playClick() {
        calibrationView?.showView(calibrationDuration: trainingService.getCalibrationDuration())
        trainingService.calibrate()
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
    
    func onCounterEnd() {
        dashboardVc?.resetPlanDashboardView()
        
        trainingService.start()
    }
    
    //MARK: private functions
    private func registerEventBus(isRegister: Bool) {
        if isRegister {
            SwiftEventBus.onMainThread(self, name: cycleStateEventBusName, handler: { result in
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
        case CycleState.calibrated:
            calibrationView?.calibrationEnd()
            startDelayView.startCounter()
        default: break
        }
    }
    
    private func setLayoutByCycleState(cycleState: CycleState) {
        switch cycleState {
        case CycleState.resumed:
            dashboardVc?.showViewSwipePause(isShow: true)
            dashboardVc?.initBtnPlaySmall(showRestart: false, isShow: false)
            dashboardVc?.refreshDashboardElements(true)
            showCloseButton(isShow: false)
            batterySaveHelper?.cycleResume()
            planSoundHelper?.cycleResume()
        case CycleState.paused:
            pauseView.showPauseView()
            dashboardVc?.showViewSwipePause(isShow: false)
            dashboardVc?.initBtnPlaySmall(showRestart: true, isShow: false)
            dashboardVc?.refreshDashboardElements(false)
            batterySaveHelper?.cyclePause()
            planSoundHelper?.cyclePause()
        case CycleState.stopped:
            dashboardVc?.showViewSwipePause(isShow: false)
            dashboardVc?.initBtnPlaySmall(showRestart: true, isShow: true)
            showCloseButton(isShow: true)
            batterySaveHelper?.cycleStop()
        default: break
        }
    }
    
    private func savePlan() {
        if let planValue = plan {
            let planTraining = PlanTraining.createPlanTraining(plan: planValue)
            planTraining.sessionId = sessionId
            
            PlanManager.sharedInstance.savePlanTraining(planTraining: planTraining)
        }
        
        if event != nil && dashboardVc!.isPlanDone {
            event!.sessionId = sessionId
            
            EventManager.sharedInstance.saveEvent(event: event!, managerCallBack: nil)
        }
    }
    
    private func showCloseButton(isShow: Bool) {
        if isShow {
            dashboardVc?.showCloseButton()
        } else {
            dashboardVc?.removeCloseButton()
        }
    }
    
    private func keepScreenOn(isOn: Bool) {
        WindowHelper.keepScreenOn(isOn: isOn)
        WindowHelper.setBrightness(isFull: true)
    }
    
}
