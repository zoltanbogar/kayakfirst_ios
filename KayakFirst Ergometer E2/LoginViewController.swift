//
//  LoginViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    private func initView() {
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(40, 40, 40, 40))
        }
        
        stackView.addArrangedSubview(tfUserName)
        
        tfUserName.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(tfPassword)
        
        tfPassword.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(btnLogin)
        
        btnLogin.snp.makeConstraints{ make in
            make.height.equalTo(40)
        }
        
        stackView.addArrangedSubview(btnForgotPassword)
        
        let spacing = UIView()
        spacing.setContentHuggingPriority(500, for: .vertical)
        stackView.addArrangedSubview(spacing)
        
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
        let button = getKayakButton(width: 0, height: 0, text: try! getString("user_login"), backgroundColor: Colors.colorAccent, textColor: Colors.colorWhite)
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
        let button = getKayakButton(width: 0, height: 0, text: try! getString("delay_quick_start"), backgroundColor: Colors.colorWhite, textColor: Colors.colorPrimaryDark)
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
    
    @objc private func btnLoginClick() {
        log("LOGIN", "btnLoginClick")
    }
    
    @objc private func btnForgotPasswordClick() {
        ResetPasswordDialog().show()
    }
    
    @objc private func btnQuickStartClick() {
    log("LOGIN", "btnQuickStartClick")
    }
}
