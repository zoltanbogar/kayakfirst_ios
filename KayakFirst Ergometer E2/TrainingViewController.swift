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

class TrainingViewController: PortraitNavController {
    
    //MARK: properties
    var trainingEnvType: TrainingEnvironmentType!
    
    var plan: Plan?
    var event: Event?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushViewController(SetDashboardVc(), animated: true)
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
    
}
