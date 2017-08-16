//
//  TrainingViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import CoreBluetooth

func startTrainingViewController(viewController: UIViewController, trainingEnvType: TrainingEnvironmentType) {
    startTrainingViewController(viewController: viewController, plan: nil, event: nil, trainingEnvType: trainingEnvType)
}

func startTrainingViewController(viewController: UIViewController, plan: Plan?, event: Event?, trainingEnvType: TrainingEnvironmentType) {
    let trainingVc = TrainingViewController()
    trainingVc.plan = plan
    trainingVc.event = event
    trainingVc.trainingEnvType = trainingEnvType
    viewController.present(trainingVc, animated: true, completion: nil)
}

class TrainingViewController: PortraitNavController, StartDelayDelegate, CalibrationDelegate, OnBluetoothConnectedListener {
    
    //MARK: properties
    private var progressView: ProgressView?
    private var startDelayView: StartDelayView?
    var calibrationView: CalibrationView?
    let telemetry = Telemetry.sharedInstance
    let outdoorService = OutdoorService.sharedInstance
    let ergometerService = ErgometerService.sharedInstance
    var plan: Plan?
    var event: Event?
    var trainingEnvType: TrainingEnvironmentType?
    
    private var dashboardVc: DashboardVc?
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        interactivePopGestureRecognizer?.isEnabled = false
        
        showDefaultVc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keepScreenOn()
    }
    
    private func showDefaultVc() {
        if let trainingEnvironmentType = trainingEnvType {
            if trainingEnvironmentType == TrainingEnvironmentType.outdoor {
                showSetDashboard()
            } else if trainingEnvironmentType == TrainingEnvironmentType.ergometer {
                showBluetoothVc()
            }
        }
    }
    
    //MARK: training
    func showSetDashboard() {
        if plan == nil {
            //TODO: test it
            /*if viewControllers.count > 0 {
                popViewController(animated: true)
            } else {
                pushViewController(SetDashboardVc(), animated: true)
            }*/
            
            let setDashboardVc = SetDashboardVc()
            
            if trainingEnvType == TrainingEnvironmentType.outdoor {
                setDashboardVc.showCloseButton()
            } else {
                setDashboardVc.showCustomBackButton()
            }
            
            pushViewController(setDashboardVc, animated: true)
        } else {
            showDashboard()
        }
    }
    func showDashboard() {
        //TODO: test - if works Android as well
        //telemetry.cycleState = CycleState.idle
        dashboardVc = DashboardVc()
        dashboardVc!.plan = plan
        dashboardVc!.event = event
        pushViewController(dashboardVc!, animated: true)
    }
    func showBluetoothVc() {
        ergometerService.onBluetoothConnectedListener = self
        pushViewController(BluetoothViewController(), animated: true)
    }
    
    //TODO: show bluetooth disconnect if needed
    func closeViewController(shoudlCloseParents: Bool) {
        outdoorService.stopLocationMonitoring()
        ergometerService.onBluetoothConnectedListener = nil
        
        UIApplication.shared.isIdleTimerDisabled = false
        telemetry.cycleState = nil
        self.dismiss(animated: true, completion: {
            if shoudlCloseParents {
                (UIApplication.shared.delegate as! AppDelegate).initMainWindow()
            }
        })
    }
    
    //MARK: bluetooth
    func connectBluetooth(bluetoothDevice: CBPeripheral) {
        progressView?.show(true)
        ergometerService.connectBluetooth(bluetoothDevice: bluetoothDevice)
        telemetry.trainingServiceCycleStateChangeListener = ergometerService
    }
    
    func onConnected() {
        progressView?.show(false)
        
        showSetDashboard()
    }
    
    func onDisconnected() {
        closeViewController(shoudlCloseParents: true)
    }
    
    func onDataAvailable(stringData: String) {
        //nothing here
    }
    
    func showBluetoothDisconnectDialog() {
        BluetoothDisconnectDialog().show()
    }
    
    //MARK: button listeners
    @objc private func btnBluetoothClick() {
        showBluetoothDisconnectDialog()
    }
    
    //MARK: views
    private func initView() {
        startDelayView = StartDelayView(superView: view)
        startDelayView!.delegate = self
        
        calibrationView = CalibrationView(superView: view)
        calibrationView!.delegate = self
        
        progressView = ProgressView(superView: view)
    }
    
    lazy var bluetoothTabBarItem: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_bluetooth")?.maskWith(color: Colors.colorBluetooth).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        button.target = self
        button.action = #selector(btnBluetoothClick)
        
        return button
    }()
    
    func onCalibrationEnd() {
        onPlayClicked()
    }
    
    func onCounterEnd() {
        let beforeCycleState = telemetry.cycleState
        
        startServiceLoop(true)
        
        if CycleState.paused != beforeCycleState {
            dashboardVc!.setPlantoPlanView()
        }
    }
    
    //MARK: dashboard elements
    var dashboardLayoutDict: [Int:Int] = [0: DashBoardElement_Strokes.tagInt, 1: DashBoardElement_Actual1000.tagInt, 2: DashBoardElement_Av1000.tagInt, 3: DashBoardElement_Duration.tagInt, 4: DashBoardElement_Distance.tagInt]
    
    
    //MARK: cycle state handling
    func onPlayClicked() {
        startDelayView?.show(true)
    }
    
    func onPauseClicked() {
        switch trainingEnvType! {
        case TrainingEnvironmentType.outdoor:
            outdoorService.pauseCycle()
        case TrainingEnvironmentType.ergometer:
            ergometerService.pauseCycle()
        default:
            break
        }
    }
    
    func onStopClicked() {
        startServiceLoop(false)
    }
    
    private func startServiceLoop(_ isStart: Bool) {
        if isStart {
            switch trainingEnvType! {
            case TrainingEnvironmentType.outdoor:
                outdoorService.startCycle()
            case TrainingEnvironmentType.ergometer:
                ergometerService.startCycle()
            default:
                break
            }
        } else {
            switch trainingEnvType! {
            case TrainingEnvironmentType.outdoor:
                outdoorService.stopCycle()
            case TrainingEnvironmentType.ergometer:
                ergometerService.stopCycle()
            default:
                break
            }
        }
    }
    
    //MARK: other
    private func keepScreenOn() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
}
