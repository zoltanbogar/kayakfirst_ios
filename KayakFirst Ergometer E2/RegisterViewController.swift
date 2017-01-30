//
//  RegisterViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import M13Checkbox

class RegisterViewController: KayakScrollViewController, UITextFieldDelegate {
    
    private let viewBottomHeight: CGFloat = 100
    
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
        
        stackView.addVerticalSpacing(spacing: viewBottomHeight)
        
        let viewBottom = UIView()
        viewBottom.backgroundColor = Colors.colorPrimary
        view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(stackView.snp.left)
            make.width.equalTo(stackView.snp.width)
            make.height.equalTo(viewBottomHeight)
        }
        
        viewBottom.addSubview(checkBox)
        checkBox.snp.makeConstraints{ make in
            make.left.equalTo(viewBottom)
            make.top.equalTo(viewBottom)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        viewBottom.addSubview(labelAccept)
        labelAccept.snp.makeConstraints { make in
            make.left.equalTo(checkBox.snp.right)
            make.centerY.equalTo(checkBox.snp.centerY)
        }
        
        viewBottom.addSubview(textFieldTermsCondition)
        textFieldTermsCondition.snp.makeConstraints { make in
            make.left.equalTo(labelAccept.snp.right)
            make.bottom.equalTo(labelAccept.snp.bottom)
        }
        
        viewBottom.addSubview(btnRegister)
        btnRegister.snp.makeConstraints { make in
            make.width.equalTo(viewBottom.snp.width)
            make.left.equalTo(viewBottom.snp.left)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(viewBottom.snp.bottom)
        }
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
    
    private lazy var checkBox: M13Checkbox! = {
        let checkbox = M13Checkbox(frame: CGRect.zero)
        checkbox.boxType = .square
        checkbox.cornerRadius = 2
        checkbox.stateChangeAnimation = .expand(M13Checkbox.AnimationStyle.fill)
        checkbox.tintColor = Colors.colorWhite
        checkbox.secondaryCheckmarkTintColor = Colors.colorPrimary
        checkbox.addTarget(self, action: #selector(checkBoxTarget), for: .valueChanged)
        
        return checkbox
    }()
    
    private lazy var labelAccept: UILabel! = {
        let label = AppUILabel()
        label.text = try! getString("user_accept")
        
        return label
    }()
    
    private lazy var textFieldTermsCondition: UITextField! = {
        let textField = UITextField()
        textField.setBottomBorder(Colors.colorAccent)
        textField.textColor = Colors.colorAccent
        textField.text = try! getString("user_terms_conditions")
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var btnRegister: UIButton! = {
        let button = getKayakButton(width: 0, height: 0, text: try! getString("user_register"), backgroundColor: Colors.colorAccent, textColor: Colors.colorWhite)
        
        return button
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
    
    @objc private func checkBoxTarget() {
        log("REGISTER", "checkBox: \(checkBox.checkState)")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldTermsCondition {
            UIApplication.shared.openURL(NSURL(string: "http://kayakfirst.com/terms-conditions")! as URL)
            return false
        } else {
            return true
        }
    }
    
}
