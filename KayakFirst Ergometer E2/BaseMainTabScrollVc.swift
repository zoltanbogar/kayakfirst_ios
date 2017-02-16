//
//  BaseMainTabScrollVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class BaseMainTabScrollVc: KayakScrollViewController {
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTabBarItems()
    }
    
    func initTabBarItems() {
        self.tabBarController?.navigationItem.setRightBarButtonItems(nil, animated: true)
    }
    
    //MARK: abstract functions
    func initView() {
        fatalError("Must be implemented")
    }
}
