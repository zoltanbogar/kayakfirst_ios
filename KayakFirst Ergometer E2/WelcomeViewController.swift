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

class WelcomeViewController: BaseVC<VcWelcomeLayout> {
    
    //MARK: lifecycle
    override func onPause() {
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
        
        (UIApplication.shared.delegate as! AppDelegate).startMainWindow()
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
