//
//  LoginView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class LoginView: UIView {

    //MARK: constants
    private let socialIconHeight: CGFloat = 15
    
    //MARK: properties
    private let viewController: WelcomeViewController
    private let userManager = UserManager.sharedInstance
    
    //MARK: init
    init(viewController: WelcomeViewController) {
        self.viewController = viewController
        super.init(frame: CGRect.zero)
        
        initView()
        
        userManager.loginCallback = loginCallback
        userManager.resetPwCallback = resetPwCallback
        
        self.viewController.showProgress(baseManagerType: userManager.userStack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    private func initView() {
        let scrollView = AppScrollView(view: self)
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 13
        
        let viewLogo = UIView()
        viewLogo.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { (make) in
            make.center.equalTo(viewLogo)
            make.height.equalTo(100)
        }
        viewLogo.snp.makeConstraints { (make) in
            make.height.equalTo(120)
        }
        
        stackView.addArrangedSubview(viewLogo)
        stackView.addArrangedSubview(tfUserName)
        tfUserName.snp.makeConstraints { (make) in
            make.height.equalTo(buttonHeight)
        }
        stackView.addArrangedSubview(tfPassword)
        tfPassword.snp.makeConstraints { (make) in
            make.height.equalTo(buttonHeight)
        }
        stackView.addArrangedSubview(btnForgotPassword)
        stackView.addArrangedSubview(btnLogin)
        stackView.addArrangedSubview(btnFacebook)
        btnFacebook.addSubview(imgFacebook)
        imgFacebook.snp.makeConstraints { (make) in
            make.left.equalTo(btnFacebook).inset(UIEdgeInsetsMake(0, margin05, 0, 0))
            make.height.equalTo(socialIconHeight)
            make.width.equalTo(socialIconHeight)
            make.centerY.equalTo(btnFacebook)
        }
        stackView.addArrangedSubview(btnGoogle)
        btnGoogle.addSubview(imgGoogle)
        imgGoogle.snp.makeConstraints { (make) in
            make.left.equalTo(btnGoogle).inset(UIEdgeInsetsMake(0, margin05, 0, 0))
            make.height.equalTo(socialIconHeight)
            make.width.equalTo(socialIconHeight)
            make.centerY.equalTo(btnGoogle)
        }
        stackView.addArrangedSubview(labelNoLogin)
        stackView.addArrangedSubview(btnQuickStart)
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView.containerView)
        }
    }
    
    //MARK: views
    private lazy var imageLogo: UIImageView! = {
        let imageView = UIImageView()
        let logo = UIImage(named: "logo")
        imageView.image = logo
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        return imageView
    }()
    
    private lazy var tfUserName: DialogElementTextField! = {
        let view = DialogElementTextField()
        view.title = getString("user_name")
        
        return view
    }()
    
    private lazy var tfPassword: DialogElementTextField! = {
        let view = DialogElementTextField()
        view.title = getString("user_password")
        view.secureTextEntry = true
        
        return view
    }()
    
    private lazy var btnLogin: UIButton! = {
        let button = AppUIButton(width: 0, text: getString("user_login"), backgroundColor: Colors.colorAccent, textColor: Colors.colorPrimary)
        button.addTarget(self, action: #selector(btnLoginClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnForgotPassword: UIButton! = {
        let button = UIButton()
        button.backgroundColor = Colors.colorTransparent
        button.setTitleColor(Colors.colorWhite, for: .normal)
        button.setTitle(getString("user_forgot_password"), for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(12)
        button.addTarget(self, action: #selector(btnForgotPasswordClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnFacebook: UIButton! = {
        let button = AppUIButton(width: 0, text: getString("user_login_facebook"), backgroundColor: Colors.colorFacebook, textColor: Colors.colorPrimary)
        button.addTarget(self, action: #selector(btnFacebookClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnGoogle: UIButton! = {
        let button = AppUIButton(width: 0, text: getString("user_login_google"), backgroundColor: Colors.colorGoogle, textColor: Colors.colorPrimary)
        button.addTarget(self, action: #selector(btnGoogleClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var labelNoLogin: UILabel! = {
        let label = AppUILabel()
        label.text = ""
        label.textAlignment = .center
        label .font = label.font.withSize(12)
        
        return label
    }()
    
    private lazy var btnQuickStart: UIButton! = {
        let button = AppUIButton(width: 0, text: getString("delay_quick_start"), backgroundColor: Colors.colorGreen, textColor: Colors.colorPrimary)
        button.addTarget(self, action: #selector(btnQuickStartClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var imgFacebook: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "facebook")
        
        imageView.image = image
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        return imageView
    }()
    
    private lazy var imgGoogle: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "google")
        
        imageView.image = image
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        return imageView
    }()
    
    //MARK: button callbacks
    @objc private func btnLoginClick() {
        if !(tfUserName.text?.isEmpty)! && !(tfPassword.text?.isEmpty)! {
            let baseManagerType = userManager.login(userName: tfUserName.text!, userPassword: tfPassword.text!)
            self.viewController.showProgress(baseManagerType: baseManagerType)
        }
    }
    
    @objc private func btnForgotPasswordClick() {
        let resetPasswordDialog = ResetPasswordDialog()
        resetPasswordDialog.handler = { email in
            let baseManagerType = self.userManager.resetPassword(email: email)
            self.viewController.showProgress(baseManagerType: baseManagerType)
        }
        resetPasswordDialog.show(viewController: self.viewController)
    }
    
    @objc private func btnQuickStartClick() {
        self.viewController.showMainView(isQuickStart: true)
    }
    
    @objc private func btnFacebookClick() {
        let managerType = userManager.loginFacebook(viewController: self.viewController)
        self.viewController.showProgress(baseManagerType: managerType)
    }
    
    @objc private func btnGoogleClick() {
        let managerType = userManager.loginGoogle(viewController: self.viewController)
        self.viewController.showProgress(baseManagerType: managerType)
    }
    
    //MARK: server callbacks
    private func loginCallback(data: Bool?, error: Responses?) {
        self.viewController.dismissProgress()
        
        if data != nil && data! {
            self.viewController.showMainView(isQuickStart: false)
        } else if let userError = error {
            if error == Responses.error_registration_required {
                resetDataFields()
                viewController.showRegistrationView(socialUser: userManager.socialUser!)
            }
            
            //TODO: if keyboard is open the 'AppToast' not visible
            errorHandlingWithAlert(viewController: self.viewController, error: userError)
        }
    }
    
    private func resetPwCallback(data: Bool?, error: Responses?) {
        self.viewController.dismissProgress()
        
        if let userError = error {
            errorHandlingWithAlert(viewController: self.viewController, error: userError)
        }
    }
    
    func resetDataFields() {
        tfUserName.text = ""
        tfPassword.text = ""
    }
    
}
