//
//  TrainingViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func startTrainingViewController(vc: UIViewController, trainingEnvType: TrainingEnvironmentType, plan: Plan?, event: Event?) {
    
    let trainingVc = TrainingViewController()
    trainingVc.trainingEnvType = trainingEnvType
    trainingVc.plan = plan
    trainingVc.event = event
    
    vc.present(trainingVc, animated: true, completion: nil)
}

class TrainingViewController: PortraitNavController, CalibrationDelegate {
    
    //MARK: properties
    var trainingEnvType: TrainingEnvironmentType!
    
    var plan: Plan?
    var event: Event?
    
    private var telemetry = Telemetry.sharedInstance
    private var bluetooth = Bluetooth.sharedInstance
    private var trainingService: TrainingService!
    
    private var calibrationView: CalibrationView?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        switch trainingEnvType! {
        case TrainingEnvironmentType.ergometer:
            trainingService = ErgometerService(telemetry: telemetry, bluetooth: bluetooth)
        case TrainingEnvironmentType.outdoor:
            trainingService = OutdoorSevice(telemetry: telemetry)
        }
        
        //TODO: unbind service when click 'finish'
        trainingService.bindService(isBind: true)
        
        super.viewDidLoad()
        
        initView()
        
        //TODO
        pushViewController(SetDashboardVc(), animated: true)
    }
    
    //MARK: views
    private func initView() {
        //startDelayView = StartDelayView(superView: view)
        //startDelayView!.delegate = self
        
        addCalibrationViewIfNeeded()
    }
    
    private func addCalibrationViewIfNeeded() {
        if trainingEnvType == TrainingEnvironmentType.outdoor {
            calibrationView = CalibrationView(superView: view)
            calibrationView!.delegate = self
        }
    }
    
    //MARK: functions
    func showBluetoothDisconnectDialog() {
        //TODO
    }
    
    func showDashboardVc(dashboardLayoutDict: [Int:Int]) {
        let dashboardVc = DashboardVc()
        dashboardVc.dashboardLayoutDict = dashboardLayoutDict
        pushViewController(dashboardVc, animated: true)
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
    func onCalibrationEnd() {
        //TODO
    }
    
}
