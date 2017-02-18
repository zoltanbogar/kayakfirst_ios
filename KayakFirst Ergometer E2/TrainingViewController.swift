//
//  TrainingViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingViewController: UINavigationController {
    
    //MARK: training
    func showSetDashboard() {
        pushViewController(SetDashboardVc(), animated: true)
    }
    func showDashboard() {
        pushViewController(DashboardVc(), animated: true)
    }
}
