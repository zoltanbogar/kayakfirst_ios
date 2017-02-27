//
//  OutdoorViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

func startOutdoorViewController(viewController: UIViewController) {
    let outdoorController = OutdoorViewController()
    let setDashboardController = SetDashboardVc()
    outdoorController.pushViewController(setDashboardController, animated: false)
    viewController.present(outdoorController, animated: true, completion: nil)
}

class OutdoorViewController: TrainingViewController {
    
    //MARK: properties
    private let outdoorSerive = OutdoorService.sharedInstance
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outdoorSerive.startLocationMonitoring()
        outdoorSerive.startDashboard()
        outdoorSerive.startCycle()
    }
    
    override func closeViewController() {
        super.closeViewController()
        outdoorSerive.stopLocationMonitoring()
        outdoorSerive.stopCycle()
        outdoorSerive.stopDashboard()
    }
    
    override func getTrainingService() -> TrainingService {
        return outdoorSerive
    }
}
