//
//  RegisterView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import M13Checkbox

class RegisterView: UIView, UITextFieldDelegate {
    
    //MARK: properties
    private let viewController: WelcomeViewController
    private let userManager = UserManager.sharedInstance
    
    private var birthDate: TimeInterval?
    
    private let stackView = UIStackView()
    private let genderPickerView = UIPickerView()
    private var pickerHelperGender: PickerHelperGender?
    private let countryPickerView = UIPickerView()
    private var pickerHelperLocale: PickerHelperLocale?
    private let artOfPaddlingPickerView = UIPickerView()
    private var pickerHelperArtOfPaddling: PickerHelperArtOfPaddling?
    private let unitWeightPickerView = UIPickerView()
    private var pickerHelperUnitWeight: PickerHelperUnit?
    private let unitDistancePickerView = UIPickerView()
    private var pickerHelperUnitDistance: PickerHelperUnit?
    private let unitPacePickerView = UIPickerView()
    private var pickerHelperUnitPace: PickerHelperUnit?
    private let datePickerView = UIDatePicker()
    private var scrollView: AppScrollView?
    
    //MARK: init
    init(viewController: WelcomeViewController) {
        self.viewController = viewController
        super.init(frame: CGRect.zero)
        
        initView()
        
        pickerHelperGender = PickerHelperGender(pickerView: genderPickerView, textField: tfGender.valueTextField)
        pickerHelperLocale = PickerHelperLocale(pickerView: countryPickerView, textField: tfCountry.valueTextField)
        pickerHelperArtOfPaddling = PickerHelperArtOfPaddling(pickerView: artOfPaddlingPickerView, textField: tfArtOfPaddling.valueTextField)
        pickerHelperUnitWeight = PickerHelperUnit(pickerView: unitWeightPickerView, textField: tfUnitWeight.valueTextField)
        pickerHelperUnitDistance = PickerHelperUnit(pickerView: unitDistancePickerView, textField: tfUnitDistance.valueTextField)
        pickerHelperUnitPace = PickerHelperUnit(pickerView: unitPacePickerView, textField: tfUnitPace.valueTextField)
        
        userManager.registerCallback = registerCallback
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
        
        return textField
    }()
    
    private lazy var tfUnitWeight: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("unit_weight")
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfUnitDistance: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("unit_distance")
        textField.required = true
        
        return textField
    }()
    
    private lazy var tfUnitPace: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("unit_pace")
        textField.required = true
        
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
            let userDto = UserDto(
                lastName: tfLastName.text,
                firstName: tfFirstName.text,
                email: tfEmail.text,
                bodyWeight: UnitHelper.getMetricWeightValue(value: Double(tfWeight.text!)!, isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight!.getValue())),
                gender: pickerHelperGender!.getValue(),
                birthDate: birthDate,
                club: tfClub.text,
                country: pickerHelperLocale!.getValue(),
                artOfPaddling: pickerHelperArtOfPaddling!.getValue(),
                password: tfPassword.text,
                userName: tfUserName.text,
                unitWeight: pickerHelperUnitWeight?.getValue(),
                unitDistance: pickerHelperUnitDistance?.getValue(),
                unitPace: pickerHelperUnitPace?.getValue(),
                googleId: self.viewController.googleId,
                facebookId: self.viewController.facebookId)
            
            let managerType = userManager.register(userDto: userDto)
            viewController.showProgress(baseManagerType: managerType)
        }
    }
    
    //MARK: server callbacks
    private func registerCallback(data: Bool?, error: Responses?) {
        self.viewController.dismissProgress()
        
        if error == nil {
            viewController.showMainView(isQuickStart: false)
        } else {
            errorHandlingWithAlert(viewController: viewController, error: error!)
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
        
        if !Validate.isUserNameValid(tfUserName: tfUserName) {
            isValid = false
            viewToScroll = tfUserName
        }
        if !Validate.isPasswordValid(tfPassword: tfPassword) {
            isValid = false
            viewToScroll = tfPassword
        }
        if !Validate.isValidEmail(email: tfEmail.text) {
            tfEmail.error = getString("error_email")
            isValid = false
            viewToScroll = tfEmail
        }
        if !Validate.isValidBodyWeight(tfWeight: tfWeight) {
            isValid = false
            viewToScroll = tfWeight
        }
        if !Validate.isValidPicker(tfPicker: tfCountry) {
            isValid = false
            viewToScroll = tfCountry
        }
        if !Validate.isValidPicker(tfPicker: tfGender) {
            isValid = false
            viewToScroll = tfGender
        }
        if !Validate.isValidPicker(tfPicker: tfArtOfPaddling) {
            isValid = false
            viewToScroll = tfArtOfPaddling
        }
        if !Validate.isValidPicker(tfPicker: tfUnitWeight) {
            isValid = false
            viewToScroll = tfUnitWeight
        }
        if !Validate.isValidPicker(tfPicker: tfUnitDistance) {
            isValid = false
            viewToScroll = tfUnitDistance
        }
        if !Validate.isValidPicker(tfPicker: tfUnitPace) {
            isValid = false
            viewToScroll = tfUnitPace
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
        tfUnitWeight.text = ""
        tfUnitDistance.text = ""
        tfUnitPace.text = ""
    }
}
