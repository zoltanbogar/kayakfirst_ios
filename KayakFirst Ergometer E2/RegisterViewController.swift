//
//  RegisterViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import M13Checkbox
import DatePickerDialog

class RegisterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: constants
    private let viewBottomHeight: CGFloat = 100
    
    //MARK: properties
    private var birthDate: TimeInterval?
    private var gender: String?
    private var countryCode: String?
    
    //MARK: views
    private let stackView = UIStackView()
    private let genderPickerView = UIPickerView()
    private let countryPickerView = UIPickerView()
    private var progressView: ProgressView?
    private var scrollView: AppScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    private func initView() {
        scrollView = AppScrollView(view: view)
        stackView.axis = .vertical
        
        scrollView!.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView!.containerView).inset(UIEdgeInsetsMake(margin2, margin2, margin2, margin2))
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
            make.bottom.equalTo(view.snp.bottom).inset(UIEdgeInsetsMake(0, 0, margin2, 0))
            make.left.equalTo(stackView.snp.left)
            make.width.equalTo(stackView.snp.width)
            make.height.equalTo(viewBottomHeight)
        }
        
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
            make.left.equalTo(labelAccept.snp.right).offset(margin05)
            make.bottom.equalTo(labelAccept.snp.bottom)
        }
        
        viewBottom.addSubview(btnRegister)
        btnRegister.snp.makeConstraints { make in
            make.width.equalTo(viewBottom.snp.width)
            make.left.equalTo(viewBottom.snp.left)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(viewBottom.snp.bottom).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
        
        genderPickerView.delegate = self
        tfGender.valueTextField.inputView = genderPickerView
        
        countryPickerView.delegate = self
        tfCountry.valueTextField.inputView = countryPickerView
        
        progressView = ProgressView(superView: view)
    }
    
    private lazy var tfFirstName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_first_name")
        
        return textField
    }()
    
    private lazy var tfLastName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_last_name")
        
        return textField
    }()
    
    private lazy var tfBirthDate: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_birth_date")
        textField.isEditable = false
        textField.clickCallback = {
            self.clickBithDate()
        }
        
        return textField
    }()
    
    private lazy var tfUserName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_name")
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfPassword: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_password")
        textField.secureTextEntry = true
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfEmail: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_email")
        textField.keyBoardType = .emailAddress
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfWeight: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_weight")
        textField.keyBoardType = .numberPad
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfCountry: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_country")
        textField.required = true
        textField.text = getString("user_spinner_choose")
        
        return textField
    }()
    
    private lazy var tfGender: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_gender")
        textField.required = true
        textField.text = getString("user_spinner_choose")
        
        return textField
    }()
    
    private lazy var labelRequired: UILabel! = {
        let label = AppUILabel()
        label.text = getString("user_required_field")
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
        label.text = getString("user_accept")
        
        return label
    }()
    
    private lazy var textFieldTermsCondition: UITextField! = {
        let textField = UITextField()
        textField.setBottomBorder(Colors.colorAccent)
        textField.textColor = Colors.colorAccent
        textField.text = getString("user_terms_conditions")
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var btnRegister: AppUIButton! = {
        let button = AppUIButton(width: 0, height: 0, text: getString("user_register"), backgroundColor: Colors.colorAccent, textColor: Colors.colorWhite)
        button.addTarget(self, action: #selector(clickRegister), for: .touchUpInside)
        button.setDisabled(true)
               
        return button
    }()
    
    private func clickBithDate() {
        DatePickerDialog().show(
            title: getString("user_birth_date"),
            doneButtonTitle: getString("other_ok"),
            cancelButtonTitle: getString("other_cancel"),
            datePickerMode: .date) { date in
                if let selectedDate = date {
                    let selectedBirthDate = DateFormatHelper.getMilliSeconds(date: selectedDate)
                    
                    if selectedBirthDate >= currentTimeMillis() {
                        self.tfBirthDate.error = getString("error_birth_date")
                    } else {
                        self.birthDate = selectedBirthDate
                        
                        self.tfBirthDate.text = DateFormatHelper.getDate(dateFormat: getString("date_format"), timeIntervallSince1970: self.birthDate)
                        self.tfBirthDate.error = nil
                    }
                }
        }
    }
    
    @objc private func checkBoxTarget() {
        let isChecked = checkBox.checkState == M13Checkbox.CheckState.checked
        btnRegister.setDisabled(!isChecked)
    }
    
    @objc private func clickRegister() {
        if checkFields() {
            progressView?.show(true)
            UserService.sharedInstance.register(
                userDataCallBack: registerCallback,
                userDto: UserDto(
                    lastName: tfLastName.text,
                    firstName: tfFirstName.text,
                    email: tfEmail.text,
                    bodyWeight: Double(tfWeight.text!),
                    gender: gender,
                    birthDate: birthDate,
                    country: countryCode,
                    password: tfPassword.text,
                    userName: tfUserName.text))
        }
    }
    
    private func registerCallback(error: Responses?, userData: User?) {
        progressView?.show(false)
        if userData != nil {
            (self.tabBarController as! WelcomeViewController).showMainView()
        } else if let userError = error {
            AppService.errorHandlingWithAlert(viewController: self, error: userError)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldTermsCondition {
            UIApplication.shared.openURL(NSURL(string: "http://kayakfirst.com/terms-conditions")! as URL)
            return false
        } else {
            return true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPickerView {
            return User.genderOptions.count
        } else {
            return NSLocale.locales().count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPickerView {
            return User.genderOptions[row]
        } else {
            return NSLocale.locales()[row].countryName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPickerView {
            let selectedGender = User.genderOptions[row]
            let genderFemaleLocalized = getString("user_gender_female")
            
            if selectedGender == genderFemaleLocalized {
                gender = User.genderFemale
            } else {
                gender = User.genderMale
            }
            
            tfGender.text = selectedGender
        } else {
            countryCode = NSLocale.locales()[row].countryCode
            
            tfCountry.text = NSLocale.locales()[row].countryName
        }
    }
    
    private func checkFields() -> Bool {
        var isValid = true;
        var viewToScroll: UIView? = nil
        
        let userNameCharacters = tfUserName.text == nil ? 0 : tfUserName.text!.characters.count
        if userNameCharacters < User.minCharacterUserName {
            tfUserName.error = getString("error_user_name")
            isValid = false
            viewToScroll = tfUserName
        }
        
        let passwordCharacters = tfPassword.text == nil ? 0 : tfPassword.text!.characters.count
        if passwordCharacters < User.minCharacterPassword {
            tfPassword.error = getString("error_password")
            isValid = false
            viewToScroll = tfPassword
        }
        if !isValidEmail(email: tfEmail.text) {
            tfEmail.error = getString("error_email")
            isValid = false
            viewToScroll = tfEmail
        }
        
        let bodyWeight: Int = tfWeight.text == nil || tfWeight.text == "" ? 0 : Int(tfWeight.text!)!
        if bodyWeight < User.minBodyWeight {
            tfWeight.error = getString("error_weight")
            isValid = false
            viewToScroll = tfWeight
        }
        
        let chooseText = getString("user_spinner_choose")
        if tfCountry.text! == chooseText {
            isValid = false
            viewToScroll = tfCountry
        }
        
        if tfGender.text! == chooseText {
            isValid = false
            viewToScroll = tfGender
        }
        
        if let scroll = viewToScroll {
            scrollView!.scrollToView(view: scroll, animated: true)
        }
        
        return isValid
    }
}
