//
//  RegisterView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import M13Checkbox

class RegisterView: UIView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: properties
    private let viewController: WelcomeViewController
    
    private var birthDate: TimeInterval?
    private var gender: String?
    private var countryCode: String?
    private var artOfPaddling: String?
    
    private let stackView = UIStackView()
    private let genderPickerView = UIPickerView()
    private let countryPickerView = UIPickerView()
    private let artOfPaddlingPickerView = UIPickerView()
    private let datePickerView = UIDatePicker()
    private var scrollView: AppScrollView?
    
    //MARK: init
    init(viewController: WelcomeViewController) {
        self.viewController = viewController
        super.init(frame: CGRect.zero)
        
        initView()
        
        genderPickerView.delegate = self
        countryPickerView.delegate = self
        artOfPaddlingPickerView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    private func initView() {
        scrollView = AppScrollView(view: self)
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
    private lazy var imgLogo: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = logoHeader
        
        return imageView
    }()
    
    lazy var tfFirstName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_first_name")
        
        return textField
    }()
    
    lazy var tfLastName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_last_name")
        
        return textField
    }()
    
    private lazy var tfBirthDate: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_birth_date")
        
        self.datePickerView.datePickerMode = .date
        self.datePickerView.maximumDate = Date()
        
        textField.valueTextField.inputView = self.datePickerView
        self.datePickerView.addTarget(self, action: #selector(self.birthDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
        return textField
    }()
    
    private lazy var tfClub: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_club")
        
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
    
    lazy var tfEmail: DialogElementTextField! = {
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
        
        textField.valueTextField.inputView = self.countryPickerView
        
        return textField
    }()
    
    private lazy var tfGender: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_gender")
        textField.required = true
        
        textField.valueTextField.inputView = self.genderPickerView
        
        return textField
    }()
    
    private lazy var tfArtOfPaddling: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_art_of_paddling")
        textField.required = true
        
        textField.valueTextField.inputView = self.artOfPaddlingPickerView
        
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
        let button = AppUIButton(width: 0, text: getString("user_register"), backgroundColor: Colors.colorAccent, textColor: Colors.colorPrimary)
        button.addTarget(self, action: #selector(clickRegister), for: .touchUpInside)
        button.setDisabled(true)
        
        return button
    }()
    
    @objc private func checkBoxTarget() {
        let isChecked = checkBox.checkState == M13Checkbox.CheckState.checked
        btnRegister.setDisabled(!isChecked)
    }
    
    @objc private func clickRegister() {
        if checkFields() {
            viewController.progressView?.show(true)
            UserService.sharedInstance.register(
                userDataCallBack: registerCallback,
                userDto: UserDto(
                    lastName: tfLastName.text,
                    firstName: tfFirstName.text,
                    email: tfEmail.text,
                    bodyWeight: Double(tfWeight.text!),
                    gender: gender,
                    birthDate: birthDate,
                    club: tfClub.text,
                    country: countryCode,
                    artOfPaddling: self.artOfPaddling,
                    password: tfPassword.text,
                    userName: tfUserName.text),
                facebookId: self.viewController.facebookId,
                googleId: self.viewController.googleId)
        }
    }
    
    //MARK: server callbacks
    private func registerCallback(error: Responses?, userData: User?) {
        viewController.progressView?.show(false)
        if userData != nil {
            viewController.showMainView(isQuickStart: false)
        } else if let userError = error {
            AppService.errorHandlingWithAlert(viewController: viewController, error: userError)
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
    
    //MARK: pcikerview listener
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPickerView {
            return User.genderOptions.count
        } else if pickerView == countryPickerView {
            return NSLocale.locales().count
        } else {
            return User.artOfPaddlingOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPickerView {
            return User.genderOptions[row]
        } else if pickerView == countryPickerView {
            return NSLocale.locales()[row].countryName
        } else {
            return User.artOfPaddlingOptions[row]
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
        } else if pickerView == countryPickerView {
            countryCode = NSLocale.locales()[row].countryCode
            
            tfCountry.text = NSLocale.locales()[row].countryName
        } else if pickerView == artOfPaddlingPickerView {
            let selectedArtOfPaddling = User.artOfPaddlingOptions[row]
            
            switch selectedArtOfPaddling {
            case getString("user_art_of_paddling_racing_kayaking"):
                self.artOfPaddling = User.artOfPaddlingRacingKayaking
            case getString("user_art_of_paddling_racing_canoeing"):
                self.artOfPaddling = User.artOfPaddlingRacingCanoeing
            case getString("user_art_of_paddling_recreational_kayaking"):
                self.artOfPaddling = User.artOfPaddlingRecreationalKayaking
            case getString("user_art_of_paddling_recreational_canoeing"):
                self.artOfPaddling = User.artOfPaddlingRecreationalCanoeing
            case getString("user_art_of_paddling_sup"):
                self.artOfPaddling = User.artOfPaddlingSup
            case getString("user_art_of_paddling_dragon"):
                self.artOfPaddling = User.artOfPaddlingDragon
            case getString("user_art_of_paddling_rowing"):
                self.artOfPaddling = User.artOfPaddlingRowing
            default:
                break
            }
            
            tfArtOfPaddling.text = selectedArtOfPaddling
        }
    }
    
    func birthDatePickerValueChanged(sender: UIDatePicker) {
        
        let selectedBirthDate = DateFormatHelper.getTimestampFromDatePicker(datePicker: sender)
        
        if selectedBirthDate >= currentTimeMillis() {
            self.tfBirthDate.error = getString("error_birth_date")
        } else {
            self.birthDate = selectedBirthDate
            
            self.tfBirthDate.text = DateFormatHelper.getDate(dateFormat: DateFormatHelper.dateFormat, timeIntervallSince1970: self.birthDate)
            self.tfBirthDate.error = nil
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
        
        let chooseText = ""
        if tfCountry.text! == chooseText {
            isValid = false
            tfCountry.error = getString("user_spinner_choose")
            viewToScroll = tfCountry
        }
        
        if tfGender.text! == chooseText {
            isValid = false
            tfGender.error = getString("user_spinner_choose")
            viewToScroll = tfGender
        }
        
        if tfArtOfPaddling.text! == chooseText {
            isValid = false
            tfArtOfPaddling.error = getString("user_spinner_choose")
            viewToScroll = tfArtOfPaddling
        }

        if let scroll = viewToScroll {
            scrollView!.scrollToView(view: scroll, animated: true)
        }
        
        return isValid
    }
    
    func resetDataFields() {
        tfFirstName.text = ""
        tfLastName.text = ""
        tfUserName.text = ""
        tfPassword.text = ""
        tfEmail.text = ""
        tfBirthDate.text = ""
        tfClub.text = ""
        tfWeight.text = ""
        tfCountry.text = ""
        tfGender.text = ""
        tfArtOfPaddling.text = ""
    }
}
