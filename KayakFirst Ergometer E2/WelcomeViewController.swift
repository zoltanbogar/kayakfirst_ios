//
//  WelcomeViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import FBSDKLoginKit

import Crashlytics
import Fabric

func startWelcomeViewController(viewController: UIViewController) {
    let controller = WelcomeViewController()
    viewController.present(controller, animated: true, completion: nil)
}

class WelcomeViewController: BaseVC<VcWelcomeLayout> {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetFields()
        
        socialLogoutIfNeeded()
    }
    
    func resetFields() {
        contentLayout!.loginView.resetDataFields()
        contentLayout!.registerView.resetDataFields()
        
        contentLayout!.segmentedControl.selectedSegmentIndex = 0
        setSegmentedItem(sender: contentLayout!.segmentedControl)
    }
    
    func socialLogoutIfNeeded() {
        let userManager = UserManager.sharedInstance
        
        if userManager.getUser() == nil {
            userManager.socialLogout()
        }
    }
    
    func showMainView(isQuickStart: Bool) {
        UserManager.sharedInstance.isQuickStart = isQuickStart
        
        if !isQuickStart {
            PushNotificationHelper.uploadPushId()
        }
        
        let controller = MainTabViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    func showRegistrationView(socialUser: SocialUser) {
        contentLayout!.registerView.socialUser = socialUser
        
        contentLayout!.segmentedControl.selectedSegmentIndex = 1
        setSegmentedItem(sender: contentLayout!.segmentedControl)
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.segmentedControl.addTarget(self, action: #selector(setSegmentedItem), for: .valueChanged)
    }
    
    override func getContentLayout(contentView: UIView) -> VcWelcomeLayout {
        return VcWelcomeLayout(contentView: contentView, viewController: self)
    }
    
    //MARK: listeners
    @objc private func setSegmentedItem(sender: UISegmentedControl) {
        contentLayout!.setSegmentedItem(sender: sender)
    }
}
