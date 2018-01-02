//
//  LoginView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class LoginView: CustomUi<ViewLoginLayout> {

    //MARK: properties
    private let viewController: WelcomeViewController
    private let userManager = UserManager.sharedInstance
    
    //MARK: init
    init(viewController: WelcomeViewController) {
        self.viewController = viewController
        super.init()
        
        userManager.loginCallback = loginCallback
        userManager.resetPwCallback = resetPwCallback
        
        self.viewController.showProgress(baseManagerType: userManager.userStack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.btnLogin.addTarget(self, action: #selector(btnLoginClick), for: .touchUpInside)
        contentLayout!.btnForgotPassword.addTarget(self, action: #selector(btnForgotPasswordClick), for: .touchUpInside)
        contentLayout!.btnFacebook.addTarget(self, action: #selector(btnFacebookClick), for: .touchUpInside)
        contentLayout!.btnGoogle.addTarget(self, action: #selector(btnGoogleClick), for: .touchUpInside)
        contentLayout!.btnQuickStart.addTarget(self, action: #selector(btnQuickStartClick), for: .touchUpInside)
    }
    
    override func getContentLayout(contentView: UIView) -> ViewLoginLayout {
        return ViewLoginLayout(contentView: contentView)
    }
    
    //MARK: button callbacks
    @objc private func btnLoginClick() {
        if !(contentLayout!.tfUserName.text?.isEmpty)! && !(contentLayout!.tfPassword.text?.isEmpty)! {
            let baseManagerType = userManager.login(userName: contentLayout!.tfUserName.text!, userPassword: contentLayout!.tfPassword.text!)
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
        contentLayout!.tfUserName.text = ""
        contentLayout!.tfPassword.text = ""
    }
    
}
