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
    viewController.present(outdoorController, animated: true, completion: nil)
}

class OutdoorViewController: TrainingViewController, CycleStateChangeListener {
    
    //MARK: properties
    private let outdoorSerive = OutdoorService.sharedInstance
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        telemetry.addCycleStateChangeListener(cycleStateChangeListener: self)
        getTrainingService().startService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keepScreenOn()
        setBrightnessFull()
    }
    
    override func closeViewController() {
        super.closeViewController()
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
            case CycleState.permittionDenied:
                self.showPermittion()
            default: break
            }
        }
    }
    
    private func keepScreenOn() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func setBrightnessFull() {
        UIScreen.main.brightness = CGFloat(1)
    }
}
