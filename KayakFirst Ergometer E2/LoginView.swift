//
//  LoginView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginView: UIView {
    
    //MARK: properties
    private let viewController: WelcomeViewController
    
    //MARK: init
    init(viewController: WelcomeViewController) {
        self.viewController = viewController
        super.init(frame: CGRect.zero)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    private func initView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(imageLogo)
        stackView.addArrangedSubview(tfUserName)
        stackView.addArrangedSubview(tfPassword)
        stackView.addArrangedSubview(btnForgotPassword)
        stackView.addArrangedSubview(btnLogin)
        stackView.addArrangedSubview(btnFacebook)
        stackView.addArrangedSubview(btnGoogle)
        stackView.addArrangedSubview(labelNoLogin)
        stackView.addArrangedSubview(btnQuickStart)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    //MARK: views
    private lazy var imageLogo: UIImageView! = {
        let imageView = UIImageView()
        let logo = UIImage(named: "logo")
        imageView.image = logo
        
        return imageView
    }()
    
    private lazy var tfUserName: DialogElementTextField! = {
        let view = DialogElementTextField(frame: CGRect.zero)
        view.title = getString("user_name")
        
        return view
    }()
    
    private lazy var tfPassword: DialogElementTextField! = {
        let view = DialogElementTextField(frame: CGRect.zero)
        view.title = getString("user_password")
        view.secureTextEntry = true
        
        return view
    }()
    
    private lazy var btnLogin: UIButton! = {
        let button = AppUIButton(width: 0, height: buttonHeight, text: getString("user_login"), backgroundColor: Colors.colorAccent, textColor: Colors.colorWhite)
        button.addTarget(self, action: #selector(btnLoginClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnForgotPassword: UIButton! = {
        let button = UIButton()
        button.backgroundColor = Colors.colorTransparent
        button.setTitle(getString("user_forgot_password"), for: .normal)
        button.addTarget(self, action: #selector(btnForgotPasswordClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnFacebook: UIButton! = {
        let button = AppUIButton(width: 0, height: buttonHeight, text: getString("user_login_facebook"), backgroundColor: Colors.colorFacebook, textColor: Colors.colorWhite)
        //TODO: add image
        //button.setImage(UIImage(named: "facebook"), for: .normal)
        button.addTarget(self, action: #selector(btnFacebookClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnGoogle: UIButton! = {
        let button = AppUIButton(width: 0, height: buttonHeight, text: getString("user_login_google"), backgroundColor: Colors.colorGoogle, textColor: Colors.colorWhite)
        //TODO: add image
        //button.setImage(UIImage(named: "google"), for: .normal)
        button.addTarget(self, action: #selector(btnGoogleClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var labelNoLogin: UILabel! = {
        let label = AppUILabel()
        label.text = getString("user_login_or")
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var btnQuickStart: UIButton! = {
        let button = AppUIButton(width: 0, height: buttonHeight, text: getString("delay_quick_start"), backgroundColor: Colors.colorQuickStart, textColor: Colors.colorWhite)
        button.addTarget(self, action: #selector(btnQuickStartClick), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: button callbacks
    @objc private func btnLoginClick() {
        if !(tfUserName.text?.isEmpty)! && !(tfPassword.text?.isEmpty)! {
            self.viewController.progressView?.show(true)
            UserService.sharedInstance.login(userDataCallBack: userDataCallback, userName: tfUserName.text!, userPassword: tfPassword.text!)
        }
    }
    
    @objc private func btnForgotPasswordClick() {
        let resetPasswordDialog = ResetPasswordDialog()
        resetPasswordDialog.handler = { email in
            self.viewController.self.progressView?.show(true)
            UserService.sharedInstance.resetPassword(userDataCallBack: self.resetPasswordCallback, email: email)
        }
        resetPasswordDialog.show(viewController: self.viewController)
    }
    
    @objc private func btnQuickStartClick() {
        log("LOGIN", "btnQuickStartClick")
    }
    
    @objc private func btnFacebookClick() {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = .web
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self.viewController, handler: { (result, error) -> Void in
            if error == nil {
                if let resultValue = result {
                    if !resultValue.isCancelled {
                        //TODO: handle this
                        log("FACEBOOK", "result: \(resultValue.token.tokenString)")
                    }
                }
            }
        })
    }
    
    @objc private func btnGoogleClick() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: server callbacks
    private func userDataCallback(error: Responses?, userData: LoginDto?) {
        self.viewController.progressView?.show(false)
        if userData != nil {
            self.viewController.showMainView()
        } else if let userError = error {
            AppService.errorHandlingWithAlert(viewController: self.viewController, error: userError)
        }
    }
    
    private func resetPasswordCallback(error: Responses?, userData: Bool?) {
        self.viewController.progressView?.show(false)
        if let userError = error {
            AppService.errorHandlingWithAlert(viewController: self.viewController, error: userError)
        }
    }
    
}
