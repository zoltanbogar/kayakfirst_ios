//
//  ViewRegisterLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import M13Checkbox

class ViewRegisterLayout: BaseLayout {
    
    private let stackView = UIStackView()
    var scrollView: AppScrollView?
    
    let genderPickerView = UIPickerView()
    let countryPickerView = UIPickerView()
    let artOfPaddlingPickerView = UIPickerView()
    let unitWeightPickerView = UIPickerView()
    let unitDistancePickerView = UIPickerView()
    let unitPacePickerView = UIPickerView()
    let datePickerView = UIDatePicker()
    
    override func setView() {
        scrollView = AppScrollView(view: contentView)
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(imgLogo)
        imgLogo.snp.makeConstraints { (make) in
            make.centerX.equalTo(stackView)
        }
        stackView.addArrangedSubview(tfFirstName)
        stackView.addArrangedSubview(tfLastName)
        stackView.addArrangedSubview(tfBirthDate)
        stackView.addArrangedSubview(tfClub)
        stackView.addArrangedSubview(tfUserName)
        stackView.addArrangedSubview(tfPassword)
        stackView.addArrangedSubview(tfEmail)
        stackView.addArrangedSubview(tfWeight)
        stackView.addArrangedSubview(tfCountry)
        stackView.addArrangedSubview(tfGender)
        stackView.addArrangedSubview(tfArtOfPaddling)
        stackView.addArrangedSubview(tfUnitWeight)
        stackView.addArrangedSubview(tfUnitDistance)
        stackView.addArrangedSubview(tfUnitPace)
        stackView.addVerticalSpacing(spacing: margin)
        stackView.addArrangedSubview(labelRequired)
        
        scrollView!.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView!.containerView).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
        }
        
        let viewBottom = UIView()
        viewBottom.backgroundColor = Colors.colorPrimary
        viewBottom.addSubview(checkBox)
        checkBox.snp.makeConstraints{ make in
            make.left.equalTo(viewBottom)
            make.top.equalTo(viewBottom)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        viewBottom.addSubview(labelAccept)
        labelAccept.snp.makeConstraints { make in
            make.left.equalTo(checkBox.snp.right).offset(margin05)
            make.centerY.equalTo(checkBox.snp.centerY)
        }
        viewBottom.addSubview(textFieldTermsCondition)
        textFieldTermsCondition.snp.makeConstraints { make in
            make.left.equalTo(labelAccept.snp.left)
            make.top.equalTo(labelAccept.snp.bottom).offset(margin05)
        }
        viewBottom.addSubview(btnRegister)
        btnRegister.snp.makeConstraints { make in
            make.width.equalTo(viewBottom.snp.width)
            make.left.equalTo(viewBottom.snp.left)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(viewBottom.snp.bottom).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
        viewBottom.snp.makeConstraints { (make) in
            make.height.equalTo(130)
        }
        stackView.addVerticalSpacing(spacing: margin)
        stackView.addArrangedSubview(viewBottom)
    }
    
    //MARK: views
    lazy var imgLogo: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = logoHeader
        
        return imageView
    }()
    
    lazy var tfFirstName: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_first_name")
        
        return textField
    }()
    
    lazy var tfLastName: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_last_name")
        
        return textField
    }()
    
    lazy var tfBirthDate: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_birth_date")
        
        self.datePickerView.datePickerMode = .date
        self.datePickerView.maximumDate = Date()
        
        textField.contentLayout!.valueTextField.inputView = self.datePickerView
        
        return textField
    }()
    
    lazy var tfClub: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_club")
        
        return textField
    }()
    
    lazy var tfUserName: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_name")
        textField.required = true
        
        return textField
    }()
    
    lazy var tfPassword: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_password")
        textField.secureTextEntry = true
        textField.required = true
        
        return textField
    }()
    
    lazy var tfEmail: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_email")
        textField.keyBoardType = .emailAddress
        textField.required = true
        
        return textField
    }()
    
    lazy var tfWeight: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_weight")
        textField.keyBoardType = .numberPad
        textField.required = true
        
        return textField
    }()
    
    lazy var tfCountry: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_country")
        textField.required = true
        
        textField.contentLayout!.valueTextField.inputView = self.countryPickerView
        
        return textField
    }()
    
    lazy var tfGender: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_gender")
        textField.required = true
        
        return textField
    }()
    
    lazy var tfUnitWeight: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("unit_weight")
        textField.required = true
        
        return textField
    }()
    
    lazy var tfUnitDistance: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("unit_distance")
        textField.required = true
        
        return textField
    }()
    
    lazy var tfUnitPace: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("unit_pace")
        textField.required = true
        
        return textField
    }()
    
    lazy var tfArtOfPaddling: DialogElementTextField! = {
        let textField = DialogElementTextField()
        textField.title = getString("user_art_of_paddling")
        textField.required = true
        
        textField.contentLayout!.valueTextField.inputView = self.artOfPaddlingPickerView
        
        return textField
    }()
    
    lazy var labelRequired: UILabel! = {
        let label = AppUILabel()
        label.text = getString("user_required_field")
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var checkBox: M13Checkbox! = {
        let checkbox = M13Checkbox(frame: CGRect.zero)
        checkbox.boxType = .square
        checkbox.cornerRadius = 2
        checkbox.stateChangeAnimation = .expand(M13Checkbox.AnimationStyle.fill)
        checkbox.tintColor = Colors.colorWhite
        checkbox.secondaryCheckmarkTintColor = Colors.colorPrimary
        
        return checkbox
    }()
    
    lazy var labelAccept: UILabel! = {
        let label = AppUILabel()
        label.text = getString("user_accept")
        
        return label
    }()
    
    lazy var textFieldTermsCondition: UITextField! = {
        let textField = UITextField()
        textField.setBottomBorder(Colors.colorAccent)
        textField.textColor = Colors.colorAccent
        textField.text = getString("user_terms_conditions")
        
        return textField
    }()
    
    lazy var btnRegister: AppUIButton! = {
        let button = AppUIButton(width: 0, text: getString("user_register"), backgroundColor: Colors.colorAccent, textColor: Colors.colorPrimary)
        button.setDisabled(true)
        
        return button
    }()
    
}
