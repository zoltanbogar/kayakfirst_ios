//
//  SetDashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class SetDashboardVc: UIViewController {
    
    //MARK: lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTabBarItems()
    }
    
    //MARK: views
    func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems([btnDone], animated: true)
        self.navigationItem.setLeftBarButtonItems([btnClose], animated: true)
        
        self.title = getString("navigation_set_dashboard")
    }
    
    private lazy var btnDone: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_play_arrow_white_24dp")
        button.target = self
        button.action = #selector(btnDoneClick)
        
        return button
    }()
    
    private lazy var btnClose: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_clear_white_24dp")
        button.target = self
        button.action = #selector(btnCloseClick)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func btnDoneClick() {
        if let parent = self.navigationController as? TrainingViewController {
            parent.showDashboard()
        }
    }
    
    @objc private func btnCloseClick() {
        dismiss(animated: true, completion: nil)
    }
}
