//
//  ViewLoginLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewLoginLayout: BaseLayout {
    
    //MARK: constants
    private let socialIconHeight: CGFloat = 15
    
    override func setView() {
        let scrollView = AppScrollView(view: contentView)
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
    
    lazy var tfUserName: DialogElementTextField! = {
        let view = DialogElementTextField()
        view.title = getString("user_name")
        
        return view
    }()
    
    lazy var tfPassword: DialogElementTextField! = {
        let view = DialogElementTextField()
        view.title = getString("user_password")
        view.secureTextEntry = true
        
        return view
    }()
    
    lazy var btnLogin: UIButton! = {
        let button = AppUIButton(width: 0, text: getString("user_login"), backgroundColor: Colors.colorAccent, textColor: Colors.colorPrimary)
        
        return button
    }()
    
    lazy var btnForgotPassword: UIButton! = {
        let button = UIButton()
        button.backgroundColor = Colors.colorTransparent
        button.setTitleColor(Colors.colorWhite, for: .normal)
        button.setTitle(getString("user_forgot_password"), for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(12)
        
        return button
    }()
    
    lazy var btnFacebook: UIButton! = {
        let button = AppUIButton(width: 0, text: getString("user_login_facebook"), backgroundColor: Colors.colorFacebook, textColor: Colors.colorPrimary)
        
        return button
    }()
    
    lazy var btnGoogle: UIButton! = {
        let button = AppUIButton(width: 0, text: getString("user_login_google"), backgroundColor: Colors.colorGoogle, textColor: Colors.colorPrimary)
        
        return button
    }()
    
    lazy var labelNoLogin: UILabel! = {
        let label = AppUILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = label.font.withSize(12)
        
        return label
    }()
    
    lazy var btnQuickStart: UIButton! = {
        let button = AppUIButton(width: 0, text: getString("delay_quick_start"), backgroundColor: Colors.colorGreen, textColor: Colors.colorPrimary)
        
        return button
    }()
    
    lazy var imgFacebook: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "facebook")
        
        imageView.image = image
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        return imageView
    }()
    
    lazy var imgGoogle: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "google")
        
        imageView.image = image
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        return imageView
    }()
    
}
