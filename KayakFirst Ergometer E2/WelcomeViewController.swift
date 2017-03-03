//
//  WelcomeViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseVC, GIDSignInDelegate, GIDSignInUIDelegate {
    
    //MARK: constants
    private let segmentItems = [getString("user_login"), getString("user_register")]
    
    //MARK: properties
    private let loginRegisterView = UIView()
    var progressView: ProgressView?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGoogleSignIn()
    }
    
    func showMainView() {
        let controller = MainTabViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: init view
    override func initView() {
        contentView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(margin, 0, 0, 0))
            make.width.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin, 0, margin))
            make.centerX.equalTo(contentView)
        }
        loginRegisterView.addSubview(loginView)
        loginView.snp.makeConstraints { (make) in
            make.edges.equalTo(loginRegisterView)
        }
        contentView.addSubview(loginRegisterView)
        loginRegisterView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).inset(UIEdgeInsetsMake(margin, 0, 0, 0))
            make.left.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin, 0, 0))
            make.right.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 0, margin))
            make.bottom.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
        
        progressView = ProgressView(superView: view)
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
        let view = RegisterView()
        
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
    
    //MARK: google signin
    private func initGoogleSignIn() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            //TODO: handle this
            log("GOOGLE", "googleSignIn: \(user.profile.name), token: \(user.authentication.idToken), uri: \(user.authentication.accessToken)")
        } else {
            //TODO: handle this
            log("GOOGLE", "\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //TODO: google error
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //TODO
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}
