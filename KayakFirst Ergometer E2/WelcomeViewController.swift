//
//  WelcomeViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class WelcomeViewController: BaseVC, GIDSignInDelegate, GIDSignInUIDelegate {
    
    //MARK: constants
    private let segmentItems = [getString("user_login"), getString("user_register")]
    private let marginHorizontal: CGFloat = 30
    
    //MARK: properties
    let loginRegisterView = UIView()
    var progressView: ProgressView?
    
    var socialFirstName: String?
    var socialLastName: String?
    var socialEmail: String?
    var facebookId: String?
    var googleId: String?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGoogleSignIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetFields()
    }
    
    func resetFields() {
        loginView.resetDataFields()
        registerView.resetDataFields()
        socialFirstName = nil
        socialLastName = nil
        socialEmail = nil
        facebookId = nil
        googleId = nil
        
        segmentedControl.selectedSegmentIndex = 0
        setSegmentedItem(sender: segmentedControl)
    }
    
    func showMainView(isQuickStart: Bool) {
        UserService.sharedInstance.isQuickStart = isQuickStart
        
        let controller = MainTabViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    func showRegistrationView() {
        registerView.tfFirstName.text = socialFirstName
        registerView.tfLastName.text = socialLastName
        registerView.tfEmail.text = socialEmail
        
        segmentedControl.selectedSegmentIndex = 1
        setSegmentedItem(sender: segmentedControl)
    }
    
    //TODO: bug: orientation change when on the 'RegisterView'
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
            make.top.equalTo(segmentedControl.snp.bottom).inset(UIEdgeInsetsMake(margin, 0, 0, 0))
            make.left.equalTo(contentView).inset(UIEdgeInsetsMake(0, marginHorizontal, 0, 0))
            make.right.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 0, marginHorizontal))
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
            
            loginView.googleSignInResult(user: user)
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
