//
//  MainNavigationViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainViewController = MainViewController()
        pushViewController(mainViewController, animated: true)
    }
    
}
