//
//  MainTabViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: constants
    private let calendarTab = UITabBarItem(title: getString("navigation_calendar"), image: UIImage(named: "navigation_calendar"), tag: 0)
    private let calendarVc = CalendarVc()
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewControllers = mainViewControllers
        
        initQuickStart()
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func initQuickStart() {
        if UserManager.sharedInstance.isQuickStart {
            let viewControllers = self.viewControllers
            if let vcs = viewControllers {
                vcs[1].tabBarItem.isEnabled = false
            }
        }
    }
    
    //MARK: delegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == calendarTab {
            calendarVc.shouldRefresh = true
        }
    }
    
    //MARK: views
    private lazy var mainViewControllers: [UIViewController]! = {
        var viewControllers = [UIViewController]()
        
        let mainVc = self.getMainVc()
        let mainNavController = UINavigationController()
        mainNavController.pushViewController(mainVc, animated: false)
        let mainTab = UITabBarItem(title: getString("navigation_home"), image: UIImage(named: "navigation_home"), tag: 0)
        mainNavController.tabBarItem = mainTab
        
        let calendarNavController = UINavigationController()
        calendarNavController.pushViewController(self.calendarVc, animated: false)
        calendarNavController.tabBarItem = self.calendarTab
        
        let profileVc = ProfileVc()
        let profileNavController = UINavigationController()
        profileNavController.pushViewController(profileVc, animated: false)
        let profileTab = UITabBarItem(title: getString("navigation_profile"), image: UIImage(named: "navigation_profile"), tag: 0)
        profileNavController.tabBarItem = profileTab
        
        let settingsVc = SettingsVc()
        let settingsNavController = UINavigationController()
        settingsNavController.pushViewController(settingsVc, animated: false)
        let settingsTab = UITabBarItem(title: getString("navigation_settings"), image: UIImage(named: "navigation_about"), tag: 0)
        settingsNavController.tabBarItem = settingsTab
        
        viewControllers.append(mainNavController)
        viewControllers.append(calendarNavController)
        viewControllers.append(profileNavController)
        viewControllers.append(settingsNavController)
        
        return viewControllers
    }()
    
    private func getMainVc() -> BaseVC {
        let baseVc: BaseVC?
        
        if UserManager.sharedInstance.isQuickStart {
            baseVc = MainVc()
        } else {
            baseVc = PlanOrNotPlanVc()
        }
        return baseVc!
    }
}
