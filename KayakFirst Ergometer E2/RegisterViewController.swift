//
//  RegisterViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class RegisterViewController: KayakScrollViewController {
    
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
        
        let stackViewName = UIStackView()
        stackViewName.axis = .horizontal
        stackViewName.distribution = .fillProportionally
        stackViewName.addArrangedSubview(tfFirstName)
        stackViewName.addHorizontalSpacing(spacing: margin2)
        stackViewName.addArrangedSubview(tfLastName)
        
        stackView.addArrangedSubview(stackViewName)
        stackViewName.snp.makeConstraints { make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(tfBirthDate)
        tfBirthDate.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(tfUserName)
        tfUserName.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(tfPassword)
        tfPassword.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(tfEmail)
        tfEmail.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(tfWeight)
        tfWeight.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(tfCountry)
        tfCountry.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(tfGender)
        tfGender.snp.makeConstraints{ make in
            make.height.equalTo(76)
        }
        
        stackView.addArrangedSubview(labelRequired)
    }
    
    private lazy var tfFirstName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = try! getString("user_first_name")
        
        return textField
    }()
    
    private lazy var tfLastName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = try! getString("user_last_name")
        
        return textField
    }()
    
    private lazy var tfBirthDate: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = try! getString("user_birth_date")
        textField.isEditable = false
        textField.clickCallback = {
            self.clickBithDate()
        }
        
        return textField
    }()
    
    private lazy var tfUserName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = try! getString("user_name")
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfPassword: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = try! getString("user_password")
        textField.secureTextEntry = true
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfEmail: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = try! getString("user_email")
        textField.keyBoardType = .emailAddress
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfWeight: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = try! getString("user_weight")
        textField.keyBoardType = .numberPad
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfCountry: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = try! getString("user_country")
        textField.required = true
        textField.isEditable = false
        textField.clickCallback = {
            self.clickCountry()
        }
        
        return textField
    }()
    
    private lazy var tfGender: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = try! getString("user_gender")
        textField.required = true
        textField.isEditable = false
        textField.clickCallback = {
            self.clickGender()
        }
        
        return textField
    }()
    
    private lazy var labelRequired: UILabel! = {
        let label = AppUILabel()
        label.text = try! getString("user_required_field")
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        label.textAlignment = .right
        
        return label
    }()
    
    private func clickBithDate() {
        log("REGISTER", "clickBirthDate")
    }
    
    private func clickCountry() {
        log("REGISTER", "clickCountry")
    }
    
    private func clickGender() {
        log("REGISTER", "clickGender")
    }
    
}
