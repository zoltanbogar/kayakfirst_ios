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

class TrainingViewController: PortraitNavController, StartDelayDelegate, PauseViewDelegate, RefresDashboardHelperDelegate, GpsAvailableListener {
    
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
    
    private var refreshDashboardHelper: RefreshDashboardHelper?
    private var batterySaveHelper: BatterySaveHelper?
    var planSoundHelper: PlanSoundHelper? {
        didSet {
            planSoundHelper?.onResume()
        }
    }
    
    override var rotationEnabled: Bool {
        return trainingEnvType == TrainingEnvironmentType.ergometer
    }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        initTrainingService()
        
        trainingService.bindService(isBind: true)
        registerEventBus(isRegister: true)
        refreshDashboardHelper = RefreshDashboardHelper.getInstance(delegate: self)
        
        super.viewDidLoad()
        
        initView()
        
        checkPlanLayout()
    }
    
    func onResume() {
        keepScreenOn(isOn: true)
        
        batterySaveHelper?.onResume()
        refreshDashboardHelper?.onResume()
        planSoundHelper?.onResume()
    }
    
    func onPause() {
        keepScreenOn(isOn: false)
        
        batterySaveHelper?.onPause()
        refreshDashboardHelper?.onPause()
        planSoundHelper?.onPause()
    }
    
    //MARK: views
    private func initView() {
        view.addSubview(labelGpsAvailable)
        labelGpsAvailable.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        startDelayView = StartDelayView(superView: view)
        startDelayView.delegate = self
        
        pauseView = PauseView(superView: view)
        pauseView.delegate = self
        
        calibrationView = CalibrationView(superView: view)
        
        restoreLayout()
    }
    
    //MARK: public functions
    func handlePortraitLayout() {
        pauseView.contentLayout!.handlePortraitLayout(size: CGSize.zero)
    }
    
    func handleLandscapeLayout() {
        pauseView.contentLayout!.handleLandscapeLayout(size: CGSize.zero)
    }
    
    func initBatterySaveHelper() {
        batterySaveHelper = BatterySaveHelper(menuItem: dashboardVc!.contentLayout!.btnPowerSaveOff)
    }
    
    func finish() {
        plan = nil
        trainingService.destroy()
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
        
        trainingService?.idle()
    }
    
    func showDashboardVc(plan: Plan) {
        dashboardVc = DashboardVc()
        dashboardVc!.plan = plan
        pushViewController(dashboardVc!, animated: true)
        
        trainingService?.idle()
    }
    
    func checkPlanLayout() {
        if let plan = plan {
            telemetry.plan = plan
            showDashboardVc(plan: plan)
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
        trainingService.start()
    }
    
    //MARK: delegate
    func refreshUi() {
        dashboardVc?.refreshUi()
    }
    
    func gpsAvailabilityChanged(isAvailable: Bool) {
        labelGpsAvailable.isHidden = isAvailable
    }
    
    private func restoreLayout() {
        if let cycleState = telemetry.cycleState {
            setLayoutByCycleState(cycleState: cycleState)
        }
    }
    
    //MARK: private functions
    private func initTrainingService() {
        switch trainingEnvType! {
        case TrainingEnvironmentType.ergometer:
            trainingService = ErgometerService.getInstance(bluetooth: bluetooth)
        case TrainingEnvironmentType.outdoor:
            trainingService = OutdoorSevice.getInstance(gpsAvailableListener: self)
        }
    }
    
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
        default: break
        }
        setLayoutByCycleState(cycleState: cycleState)
    }
    
    private func setLayoutByCycleState(cycleState: CycleState) {
        switch cycleState {
        case CycleState.idle:
            showCloseButton(isShow: true)
            dashboardVc?.initBtnPlaySmall(showRestart: false, isShow: true)
        case CycleState.calibrated:
            calibrationView?.calibrationEnd()
            startDelayView.startCounter()
        case CycleState.resumed:
            sessionId = telemetry.sessionId
            dashboardVc?.showViewSwipePause(isShow: true)
            dashboardVc?.initBtnPlaySmall(showRestart: false, isShow: false)
            showCloseButton(isShow: false)
            batterySaveHelper?.cycleResume()
            planSoundHelper?.cycleResume()
            refreshDashboardHelper?.cycleResume()
        case CycleState.paused:
            pauseView.showPauseView()
            dashboardVc?.showViewSwipePause(isShow: false)
            dashboardVc?.initBtnPlaySmall(showRestart: true, isShow: false)
            batterySaveHelper?.cyclePause()
            planSoundHelper?.cyclePause()
            refreshDashboardHelper?.cyclePause()
        case CycleState.stopped:
            dashboardVc?.showViewSwipePause(isShow: false)
            dashboardVc?.initBtnPlaySmall(showRestart: true, isShow: true)
            showCloseButton(isShow: true)
            batterySaveHelper?.cycleStop()
            planSoundHelper?.cycleStop()
            refreshDashboardHelper?.cycleStop()
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
    
    //MARK: views
    //TODO: real implementaion
    private lazy var labelGpsAvailable: UILabel! = {
        let label = UILabel()
        
        label.text = "GPS SIGNAL WEEK!"
        label.backgroundColor = Colors.colorAccent
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        label.isHidden = true
        
        return label
    }()
    
}
