//
//  TrainingViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingViewController: UINavigationController {
    
    //MARK: lifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    //MARK: abstract functions
    func getTrainingService() -> TrainingService {
        fatalError("Must be implemented")
    }
    
    //MARK: training
    func showSet1Dashboard() {
        pushViewController(SetDashboardVc(), animated: true)
    }
    func showDashboard() {
        pushViewController(DashboardVc(), animated: true)
    }
    func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: dashboard elements
    var dashboardLayoutDict: [Int:Int] = [0: DashBoardElement_Duration.tagInt, 1: DashBoardElement_Distance.tagInt, 2: DashBoardElement_Av1000.tagInt, 3: DashBoardElement_Actual1000.tagInt, 4: DashBoardElement_Strokes.tagInt]
}
