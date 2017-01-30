//
//  LoginViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class LoginViewController: KayakScrollViewController {
    
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    private func initView() {
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
        view.title = try! getString("user_name")
        
        return view
    }()
    
    private lazy var tfPassword: DialogElementTextField! = {
        let view = DialogElementTextField(frame: CGRect.zero)
        view.title = try! getString("user_password")
        
        return view
    }()
    
    private lazy var btnLogin: UIButton! = {
        let button = getKayakButton(width: 0, height: buttonHeight, text: try! getString("user_login"), backgroundColor: Colors.colorAccent, textColor: Colors.colorWhite)
        button.addTarget(self, action: #selector(btnLoginClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnForgotPassword: UIButton! = {
        let button = UIButton()
        button.backgroundColor = Colors.colorTransparent
        button.setTitle(try! getString("user_forgot_password"), for: .normal)
        button.addTarget(self, action: #selector(btnForgotPasswordClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnQuickStart: UIButton! = {
        let button = getKayakButton(width: 0, height: buttonHeight, text: try! getString("delay_quick_start"), backgroundColor: Colors.colorWhite, textColor: Colors.colorPrimaryDark)
        button.addTarget(self, action: #selector(btnQuickStartClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var labelNoLogin: UILabel! = {
        let label = UILabel()
        label.text = try! getString("user_login_no_login")
        label.textColor = Colors.colorWhite
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var labelNoLoginData: UILabel! = {
        let label = UILabel()
        label.text = try! getString("user_login_no_data")
        label.textColor = Colors.colorWhite
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var labelSocial: UILabel! = {
        let label = UILabel()
        label.text = try! getString("user_login_social")
        label.textColor = Colors.colorWhite
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
        log("LOGIN", "btnLoginClick")
    }
    
    @objc private func btnForgotPasswordClick() {
        ResetPasswordDialog().show()
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
}
