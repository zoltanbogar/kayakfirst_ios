//
//  LoginViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class LoginViewController: KayakScrollViewController {
    
    //MARK: views
    private let stackView = UIStackView()
    private var progressView: ProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    private func initView() {
        progressView = ProgressView(superView: view)
        
        stackView.axis = .vertical
        
        containerView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(UIEdgeInsetsMake(margin2, margin2, margin2, margin2))
        }
        
        stackView.addArrangedSubview(tfUserName)
        
        tfUserName.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(tfPassword)
        
        tfPassword.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(labelSocial)
        
        stackView.addVerticalSpacing(spacing: 10)
        
        let stackViewSocial = UIStackView()
        stackViewSocial.axis = .horizontal
        stackViewSocial.addArrangedSubview(btnLogin)
        stackViewSocial.addHorizontalSpacing(spacing: margin)
        stackViewSocial.addArrangedSubview(btnFacebook)
        stackViewSocial.addHorizontalSpacing(spacing: margin)
        stackViewSocial.addArrangedSubview(btnGoogle)
        
        stackView.addArrangedSubview(stackViewSocial)
        
        stackViewSocial.snp.makeConstraints{ make in
            make.height.equalTo(buttonHeight)
        }
        
        btnFacebook.snp.makeConstraints { make in
            make.width.equalTo(buttonHeight)
        }
        
        btnGoogle.snp.makeConstraints { make in
            make.width.equalTo(buttonHeight)
        }
        
        stackView.addVerticalSpacing(spacing: margin)
        
        stackView.addArrangedSubview(btnForgotPassword)
        
        stackView.addVerticalSpacing(spacing: 100)
        
        stackView.addArrangedSubview(labelNoLogin)
        stackView.addArrangedSubview(labelNoLoginData)
        stackView.addArrangedSubview(btnQuickStart)
    }
    
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
    
    private lazy var btnQuickStart: UIButton! = {
        let button = AppUIButton(width: 0, height: buttonHeight, text: getString("delay_quick_start"), backgroundColor: Colors.colorWhite, textColor: Colors.colorPrimaryDark)
        button.addTarget(self, action: #selector(btnQuickStartClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var labelNoLogin: UILabel! = {
        let label = AppUILabel()
        label.text = getString("user_login_no_login")
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var labelNoLoginData: UILabel! = {
        let label = AppUILabel()
        label.text = getString("user_login_no_data")
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var labelSocial: UILabel! = {
        let label = AppUILabel()
        label.text = getString("user_login_social")
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var btnFacebook: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "facebook"), for: .normal)
        button.addTarget(self, action: #selector(btnFacebookClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnGoogle: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "google"), for: .normal)
        button.addTarget(self, action: #selector(btnGoogleClick), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func btnLoginClick() {
        if !(tfUserName.text?.isEmpty)! && !(tfPassword.text?.isEmpty)! {
            progressView?.show(isShow: true)
            UserService.sharedInstance.login(userDataCallBack: userDataCallback, userName: tfUserName.text!, userPassword: tfPassword.text!)
        }
    }
    
    @objc private func btnForgotPasswordClick() {
        let resetPasswordDialog = ResetPasswordDialog()
        resetPasswordDialog.handler = { email in
            self.progressView?.show(isShow: true)
            UserService.sharedInstance.resetPassword(userDataCallBack: self.resetPasswordCallback, email: email)
        }
        resetPasswordDialog.show()
    }
    
    private func resetPasswordCallback(error: Responses?, userData: Bool?) {
        progressView?.show(isShow: false)
        if let userError = error {
            AppService.errorHandlingWithAlert(viewController: self, error: userError)
        }
    }

    @objc private func btnQuickStartClick() {
        log("LOGIN", "btnQuickStartClick")
    }
    
    @objc private func btnFacebookClick() {
        log("LOGIN", "btnFacebookClick")
    }
    
    @objc private func btnGoogleClick() {
        log("LOGIN", "btnGoogleClick")
    }
    
    private func userDataCallback(error: Responses?, userData: LoginDto?) {
        progressView?.show(isShow: false)
        if userData != nil {
            (self.tabBarController as! WelcomeViewController).showMainView()
        } else if let userError = error {
            AppService.errorHandlingWithAlert(viewController: self, error: userError)
        }
    }
    
    //TODO: delete this
    private func showProfile() {
        if UserService.sharedInstance.getUser() != nil {
            let viewController = ProfileViewController()
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
