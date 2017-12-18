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

class WelcomeViewController: BaseVC {
    
    //MARK: constants
    private let segmentItems = [getString("user_login"), getString("user_register")]
    private let marginHorizontal: CGFloat = 30
    
    //MARK: properties
    let loginRegisterView = UIView()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetFields()
        
        socialLogoutIfNeeded()
    }
    
    func resetFields() {
        loginView.resetDataFields()
        registerView.resetDataFields()
        
        segmentedControl.selectedSegmentIndex = 0
        setSegmentedItem(sender: segmentedControl)
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
        registerView.socialUser = socialUser
        
        segmentedControl.selectedSegmentIndex = 1
        setSegmentedItem(sender: segmentedControl)
    }
    
    //MARK: init view
    override func initView() {
        contentView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
            make.width.equalTo(contentView).inset(UIEdgeInsetsMake(0, marginHorizontal, 0, marginHorizontal))
            make.centerX.equalTo(contentView)
        }
        loginRegisterView.addSubview(loginView)
        loginView.snp.makeConstraints { (make) in
            make.edges.equalTo(loginRegisterView)
        }
        contentView.addSubview(loginRegisterView)
        loginRegisterView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(margin)
            make.left.equalTo(contentView).inset(UIEdgeInsetsMake(0, marginHorizontal, 0, 0))
            make.right.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 0, marginHorizontal))
            make.bottom.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
    }
    
    //MARK: views
    private lazy var segmentedControl: UISegmentedControl! = {
        let control = UISegmentedControl(items: self.segmentItems)
        control.tintColor = Colors.colorAccent
        control.addTarget(self, action: #selector(setSegmentedItem), for: .valueChanged)
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    private lazy var loginView: LoginView! = {
        let view = LoginView(viewController: self)
        
        return view
    }()
    
    private lazy var registerView: RegisterView! = {
        let view = RegisterView(viewController: self)
        
        return view
    }()
    
    //MARK: listeners
    @objc private func setSegmentedItem(sender: UISegmentedControl) {
        let viewSub: UIView
        switch sender.selectedSegmentIndex {
        case 1:
            viewSub = registerView
        default:
            viewSub = loginView
        }
        
        loginRegisterView.removeAllSubviews()
        loginRegisterView.addSubview(viewSub)
        viewSub.snp.makeConstraints { make in
            make.edges.equalTo(loginRegisterView)
        }
    }
}
