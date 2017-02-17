//
//  OutdoorViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

func startOutdoorViewController(viewController: UIViewController) {
    let trainingController = TrainingViewController()
    let setDashboardController = SetDashboardVc()
    trainingController.pushViewController(setDashboardController, animated: false)
    viewController.present(trainingController, animated: true, completion: nil)
}

class OutdoorViewController: TrainingViewController {
    
    //TODO
}
