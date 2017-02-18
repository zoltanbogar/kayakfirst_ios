//
//  MainTabViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewControllers = mainViewControllers
    }
    
    //MARK: views
    private lazy var mainViewControllers: [UIViewController]! = {
        var viewControllers = [UIViewController]()
        
        let mainVc = MainVc()
        let mainNavController = TrainingViewController()
        mainNavController.pushViewController(mainVc, animated: false)
        let mainTab = UITabBarItem(title: getString("navigation_home"), image: nil, tag: 0)
        mainNavController.tabBarItem = mainTab
        
        let calendarVc = CalendarVc()
        let calendarNavController = UINavigationController()
        calendarNavController.pushViewController(calendarVc, animated: false)
        let calendarTab = UITabBarItem(title: getString("navigation_calendar"), image: nil, tag: 0)
        calendarNavController.tabBarItem = calendarTab
        
        let profileVc = ProfileVc()
        let profileNavController = UINavigationController()
        profileNavController.pushViewController(profileVc, animated: false)
        let profileTab = UITabBarItem(title: getString("navigation_profile"), image: nil, tag: 0)
        profileNavController.tabBarItem = profileTab
        
        let settingsVc = SettingsVc()
        let settingsNavController = UINavigationController()
        settingsNavController.pushViewController(settingsVc, animated: false)
        let settingsTab = UITabBarItem(title: getString("navigation_settings"), image: nil, tag: 0)
        settingsNavController.tabBarItem = settingsTab
    
        
        viewControllers.append(mainNavController)
        viewControllers.append(calendarNavController)
        viewControllers.append(profileNavController)
        viewControllers.append(settingsNavController)
        
        return viewControllers
    }()
    
}
