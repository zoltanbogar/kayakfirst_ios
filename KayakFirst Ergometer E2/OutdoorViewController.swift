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

class OutdoorViewController: TrainingViewController, CycleStateChangeListener {
    
    //MARK: properties
    private let outdoorSerive = OutdoorService.sharedInstance
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        telemetry.addCycleStateChangeListener(cycleStateChangeListener: self)
        outdoorSerive.startLocationMonitoring()
    }
    
    override func closeViewController() {
        super.closeViewController()
        outdoorSerive.stopLocationMonitoring()
    }
    
    override func getTrainingService() -> TrainingService {
        return outdoorSerive
    }
    
    func onCycleStateChanged(newCycleState: CycleState) {
        DispatchQueue.main.async {
            switch newCycleState {
            case CycleState.none:
                self.showSetDashboard()
            case CycleState.idle:
                self.showDashboard()
            default: break
            }
        }
    }
}
