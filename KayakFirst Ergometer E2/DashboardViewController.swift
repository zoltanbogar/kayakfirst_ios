//
//  DashboardViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var btnPlay: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initToolbar()
    }

    private func initToolbar() {
        btnPlay.customView = getRoundedButton(width: 40, image: UIImage(named: "play_24dp")!, color: Colors.colorAccent)
    }
}

