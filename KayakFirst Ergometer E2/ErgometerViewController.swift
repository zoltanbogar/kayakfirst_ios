//
//  ErgometerViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

func startErgometerViewController(viewController: UIViewController) {
    let ergoController = ErgometerViewController()
    let ergoComingSoon = ErgoComingSoonVc()
    ergoController.pushViewController(ergoComingSoon, animated: false)
    viewController.present(ergoController, animated: true, completion: nil)
}

class ErgometerViewController: TrainingViewController {
    
    //TODO
    
}
