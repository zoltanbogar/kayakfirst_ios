//
//  VcSettingsLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcSettingsLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(imgLogo)
        contentView.addSubview(textFieldWebsite)
        contentView.addSubview(textFieldTermsCondition)
        contentView.addSubview(textFieldFeedback)
        contentView.addSubview(labelVersion)
    }
    
    override func handlePortraitLayout(size: CGSize) {
        imgLogo.snp.removeConstraints()
        textFieldWebsite.snp.removeConstraints()
        textFieldTermsCondition.snp.removeConstraints()
        textFieldFeedback.snp.removeConstraints()
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
        
        textFieldFeedback.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(textFieldTermsCondition.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin2, 0))
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
        textFieldFeedback.snp.removeConstraints()
        labelVersion.snp.removeConstraints()
        
        imgLogo.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)
        }
        
        textFieldWebsite.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imgLogo.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin05, 0))
        }
        
        textFieldTermsCondition.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(textFieldWebsite.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin05, 0))
        }
        
        textFieldFeedback.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(textFieldTermsCondition.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin05, 0))
        }
        
        labelVersion.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(textFieldFeedback.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin05, 0))
            make.bottom.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, margin05, 0))
        }
    }
    
    //MARK: views
    lazy var imgLogo: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "logo")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var textFieldWebsite: UITextField! = {
        let textField = UITextField()
        textField.setBottomBorder(Colors.colorWhite)
        textField.textColor = Colors.colorWhite
        textField.text = getString("app_link")
        
        return textField
    }()
    
    lazy var textFieldTermsCondition: UITextField! = {
        let textField = UITextField()
        textField.setBottomBorder(Colors.colorWhite)
        textField.textColor = Colors.colorWhite
        textField.text = getString("user_terms_conditions_short")
        
        return textField
    }()
    
    lazy var textFieldFeedback: UITextField! = {
        let textField = UITextField()
        textField.setBottomBorder(Colors.colorWhite)
        textField.textColor = Colors.colorWhite
        textField.text = getString("feedback_title")
        
        return textField
    }()
    
    lazy var labelVersion: UILabel! = {
        let label = UILabel()
        label.text = getString("app_version") + " " + AppDelegate.versionString
        label.textColor = Colors.colorGrey
        
        return label
    }()
    
}
