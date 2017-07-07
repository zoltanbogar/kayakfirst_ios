//
//  TrainingViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

func startTrainingViewController(viewController: UIViewController) {
    viewController.present(TrainingViewController(), animated: true, completion: nil)
}

func startTrainingViewController(viewController: UIViewController, plan: Plan?, event: Event?, trainingEnvType: TrainingEnvironmentType) {
    let trainingVc = TrainingViewController()
    trainingVc.plan = plan
    trainingVc.event = event
    viewController.present(trainingVc, animated: true, completion: nil)
}

class TrainingViewController: UINavigationController, StartDelayDelegate, CalibrationDelegate {
    
    //MARK: properties
    private var startDelayView: StartDelayView?
    var calibrationView: CalibrationView?
    let telemetry = Telemetry.sharedInstance
    let outdoorService = OutdoorService.sharedInstance
    var plan: Plan?
    var event: Event?
    private var dashboardVc: DashboardVc?
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        interactivePopGestureRecognizer?.isEnabled = false
        
        showSetDashboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keepScreenOn()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    //MARK: screen orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func getTrainingService() -> TrainingService {
        return outdoorService
    }
    
    //MARK: training
    func showSetDashboard() {
        if plan == nil {
            if viewControllers.count > 0 {
                popViewController(animated: true)
            } else {
                pushViewController(SetDashboardVc(), animated: true)
            }
        } else {
            showDashboard()
        }
    }
    func showDashboard() {
        telemetry.cycleState = CycleState.idle
        dashboardVc = DashboardVc()
        dashboardVc!.plan = plan
        pushViewController(dashboardVc!, animated: true)
    }
    
    func closeViewController() {
        outdoorService.stopLocationMonitoring()
        UIApplication.shared.isIdleTimerDisabled = false
        telemetry.cycleState = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: views
    private func initView() {
        startDelayView = StartDelayView(superView: view)
        startDelayView!.delegate = self
        
        calibrationView = CalibrationView(superView: view)
        calibrationView!.delegate = self
    }
    
    func onCalibrationEnd() {
        onPlayClicked()
    }
    
    func onCounterEnd() {
        startServiceLoop(true)
        dashboardVc!.setPlantoPlanView()
    }
    
    //MARK: dashboard elements
    var dashboardLayoutDict: [Int:Int] = [0: DashBoardElement_Strokes.tagInt, 1: DashBoardElement_Actual1000.tagInt, 2: DashBoardElement_Av1000.tagInt, 3: DashBoardElement_Duration.tagInt, 4: DashBoardElement_Distance.tagInt]
    
    
    //MARK: cycle state handling
    func onPlayClicked() {
        startDelayView?.show(true)
    }
    
    func onPauseClicked() {
        getTrainingService().pauseCycle()
    }
    
    func onStopClicked() {
        startServiceLoop(false)
    }
    
    private func startServiceLoop(_ isStart: Bool) {
        if isStart {
            getTrainingService().startCycle()
        } else {
            getTrainingService().stopCycle()
        }
    }
    
    //MARK: other
    private func keepScreenOn() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
}
