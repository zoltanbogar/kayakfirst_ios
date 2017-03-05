//
//  SettingsVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class SettingsVc: MainTabVc, UITextFieldDelegate {
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTitle()
    }
    
    //MARK: init view
    override func initView() {
        contentView.addSubview(imgLogo)
        contentView.addSubview(textFieldWebsite)
        contentView.addSubview(textFieldTermsCondition)
        contentView.addSubview(labelVersion)
    }
    
    override func handlePortraitLayout(size: CGSize) {
        imgLogo.snp.removeConstraints()
        textFieldWebsite.snp.removeConstraints()
        textFieldTermsCondition.snp.removeConstraints()
        labelVersion.snp.removeConstraints()
        
        imgLogo.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(margin, 0, 0, 0))
        }
        
        textFieldWebsite.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imgLogo.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin2 * 2, 0))
        }
        
        textFieldTermsCondition.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(textFieldWebsite.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin2, 0))
        }
        
        labelVersion.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        imgLogo.snp.removeConstraints()
        textFieldWebsite.snp.removeConstraints()
        textFieldTermsCondition.snp.removeConstraints()
        labelVersion.snp.removeConstraints()
        
        imgLogo.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)        }
        
        textFieldWebsite.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imgLogo.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin05, 0))
        }
        
        textFieldTermsCondition.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(textFieldWebsite.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin05, 0))
        }
        
        labelVersion.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
    }
    
    private func initTitle() {
        title = getString("navigation_settings")
    }
    
    //MARK: views
    private lazy var imgLogo: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "logo")
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var textFieldWebsite: UITextField! = {
        let textField = UITextField()
        textField.setBottomBorder(Colors.colorWhite)
        textField.textColor = Colors.colorWhite
        textField.text = getString("app_link")
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var textFieldTermsCondition: UITextField! = {
        let textField = UITextField()
        textField.setBottomBorder(Colors.colorWhite)
        textField.textColor = Colors.colorWhite
        textField.text = getString("user_terms_conditions")
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var labelVersion: UILabel! = {
        let label = UILabel()
        label.text = getString("app_version") + AppDelegate.versionString
        label.textColor = Colors.colorQuickStart
        
        return label
    }()
    
    //MARK: callbacks
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldTermsCondition {
            UIApplication.shared.openURL(NSURL(string: "http://kayakfirst.com/terms-conditions")! as URL)
            return false
        } else if textField == textFieldWebsite {
            UIApplication.shared.openURL(NSURL(string: "http://kayakfirst.com")! as URL)
            return false
        } else {
            return true
        }
    }
    
}
