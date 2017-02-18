//
//  WelcomeViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class WelcomeViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initViewControllers()
    }
    
    private func initViewControllers() {
        let loginController = LoginViewController()
        let tabLogin = UITabBarItem(title: getString("user_login"), image: nil, tag: 0)
        
        let registerController = RegisterViewController()
        let tabRegister = UITabBarItem(title: getString("user_register"), image: nil, tag: 1)
        
        loginController.tabBarItem = tabLogin
        registerController.tabBarItem = tabRegister
        
        let controllers = [loginController, registerController]
        self.viewControllers = controllers
    }
    
    func showMainView() {
        let controller = MainTabViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
}
