//
//  TrainingViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingViewController: UINavigationController, StartDelayDelegate {
    
    //MARK: properties
    private var startDelayView: StartDelayView?
    let telemetry = Telemetry.sharedInstance
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        interactivePopGestureRecognizer?.isEnabled = false
    }
    
    //MARK: abstract functions
    func getTrainingService() -> TrainingService {
        fatalError("Must be implemented")
    }
    
    //MARK: training
    func showSetDashboard() {
        if viewControllers.count > 0 {
            popViewController(animated: true)
        } else {
            pushViewController(SetDashboardVc(), animated: true)
        }
    }
    func showDashboard() {
        pushViewController(DashboardVc(), animated: true)
    }
    func showPermittion() {
        pushViewController(LocationPermittionVc(), animated: true)
    }
    
    func closeViewController() {
        UIApplication.shared.isIdleTimerDisabled = false
        telemetry.cycleState = CycleState.quit
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: views
    private func initView() {
        startDelayView = StartDelayView(superView: view)
        startDelayView!.delegate = self
    }
    
    func onCounterEnd() {
        startServiceLoop(true)
    }
    
    //MARK: dashboard elements
    var dashboardLayoutDict: [Int:Int] = [0: DashBoardElement_Duration.tagInt, 1: DashBoardElement_Distance.tagInt, 2: DashBoardElement_Av1000.tagInt, 3: DashBoardElement_Actual1000.tagInt, 4: DashBoardElement_Strokes.tagInt]
    
    
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
}
