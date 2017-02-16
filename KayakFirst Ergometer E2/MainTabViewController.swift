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
        let mainTab = UITabBarItem(title: getString("navigation_home"), image: nil, tag: 0)
        mainVc.tabBarItem = mainTab
        
        let calendarVc = CalendarVc()
        let calendarTab = UITabBarItem(title: getString("navigation_calendar"), image: nil, tag: 0)
        calendarVc.tabBarItem = calendarTab
        
        let profileVc = ProfileVc()
        let profileTab = UITabBarItem(title: getString("navigation_profile"), image: nil, tag: 0)
        profileVc.tabBarItem = profileTab
        
        let settingsVc = SettingsVc()
        let settingsTab = UITabBarItem(title: getString("navigation_settings"), image: nil, tag: 0)
        settingsVc.tabBarItem = settingsTab
        
        viewControllers.append(mainVc)
        viewControllers.append(calendarVc)
        viewControllers.append(profileVc)
        viewControllers.append(settingsVc)
        
        return viewControllers
    }()
    
}
