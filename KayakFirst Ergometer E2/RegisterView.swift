//
//  RegisterView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import M13Checkbox

class RegisterView: CustomUi<ViewRegisterLayout>, UITextFieldDelegate {
    
    //MARK: properties
    private let viewController: WelcomeViewController
    private let userManager = UserManager.sharedInstance
    
    private var birthDate: TimeInterval?
    
    private var pickerHelperGender: PickerHelperGender?
    private var pickerHelperLocale: PickerHelperLocale?
    private var pickerHelperArtOfPaddling: PickerHelperArtOfPaddling?
    private var pickerHelperUnitWeight: PickerHelperUnit?
    private var pickerHelperUnitDistance: PickerHelperUnit?
    private var pickerHelperUnitPace: PickerHelperUnit?
    
    private var facebookId: String?
    private var googleId: String?
    
    var socialUser: SocialUser? {
        didSet {
            contentLayout!.tfFirstName.text = socialUser?.socialFirstName
            contentLayout!.tfLastName.text = socialUser?.socialLastName
            contentLayout!.tfEmail.text = socialUser?.socialEmail
            facebookId = socialUser?.facebookId
            googleId = socialUser?.googleId
        }
    }
    
    //MARK: init
    init(viewController: WelcomeViewController) {
        self.viewController = viewController
        super.init()
        
        pickerHelperGender = PickerHelperGender(pickerView: contentLayout!.genderPickerView, textField: contentLayout!.tfGender.contentLayout!.valueTextField)
        pickerHelperLocale = PickerHelperLocale(pickerView: contentLayout!.countryPickerView, textField: contentLayout!.tfCountry.contentLayout!.valueTextField)
        pickerHelperArtOfPaddling = PickerHelperArtOfPaddling(pickerView: contentLayout!.artOfPaddlingPickerView, textField: contentLayout!.tfArtOfPaddling.contentLayout!.valueTextField)
        pickerHelperUnitWeight = PickerHelperUnit(pickerView: contentLayout!.unitWeightPickerView, textField: contentLayout!.tfUnitWeight.contentLayout!.valueTextField)
        pickerHelperUnitDistance = PickerHelperUnit(pickerView: contentLayout!.unitDistancePickerView, textField: contentLayout!.tfUnitDistance.contentLayout!.valueTextField)
        pickerHelperUnitPace = PickerHelperUnit(pickerView: contentLayout!.unitPacePickerView, textField: contentLayout!.tfUnitPace.contentLayout!.valueTextField)
        
        userManager.registerCallback = registerCallback
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.datePickerView.addTarget(self, action: #selector(self.birthDatePickerValueChanged), for: UIControlEvents.valueChanged)
        contentLayout!.checkBox.addTarget(self, action: #selector(checkBoxTarget), for: .valueChanged)
        contentLayout!.textFieldTermsCondition.delegate = self
        contentLayout!.btnRegister.addTarget(self, action: #selector(clickRegister), for: .touchUpInside)
    }
    
    override func getContentLayout(contentView: UIView) -> ViewRegisterLayout {
        return ViewRegisterLayout(contentView: contentView)
    }
    
    @objc private func checkBoxTarget() {
        let isChecked = contentLayout!.checkBox.checkState == M13Checkbox.CheckState.checked
        contentLayout!.btnRegister.setDisabled(!isChecked)
    }
    
    @objc private func clickRegister() {
        if checkFields() {
            let userDto = UserDto(
                lastName: contentLayout!.tfLastName.text,
                firstName: contentLayout!.tfFirstName.text,
                email: contentLayout!.tfEmail.text,
                bodyWeight: UnitHelper.getMetricWeightValue(value: Double(contentLayout!.tfWeight.text!)!, isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight!.getValue())),
                gender: pickerHelperGender!.getValue(),
                birthDate: birthDate,
                club: contentLayout!.tfClub.text,
                country: pickerHelperLocale!.getValue(),
                artOfPaddling: pickerHelperArtOfPaddling!.getValue(),
                password: contentLayout!.tfPassword.text,
                userName: contentLayout!.tfUserName.text,
                unitWeight: pickerHelperUnitWeight?.getValue(),
                unitDistance: pickerHelperUnitDistance?.getValue(),
                unitPace: pickerHelperUnitPace?.getValue(),
                googleId: self.googleId,
                facebookId: self.facebookId)
            
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
        if textField == contentLayout!.textFieldTermsCondition {
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
            self.contentLayout!.tfBirthDate.error = getString("error_birth_date")
        } else {
            self.birthDate = selectedBirthDate
            
            self.contentLayout!.tfBirthDate.text = DateFormatHelper.getDate(dateFormat: DateFormatHelper.dateFormat, timeIntervallSince1970: self.birthDate)
            self.contentLayout!.tfBirthDate.error = nil
        }
    }
    
    private func checkFields() -> Bool {
        var isValid = true;
        var viewToScroll: UIView? = nil
        
        if !Validate.isUserNameValid(tfUserName: contentLayout!.tfUserName) {
            isValid = false
            viewToScroll = contentLayout!.tfUserName
        }
        if !Validate.isPasswordValid(tfPassword: contentLayout!.tfPassword) {
            isValid = false
            viewToScroll = contentLayout!.tfPassword
        }
        if !Validate.isValidEmail(email: contentLayout!.tfEmail.text) {
            contentLayout!.tfEmail.error = getString("error_email")
            isValid = false
            viewToScroll = contentLayout!.tfEmail
        }
        if !Validate.isValidBodyWeight(tfWeight: contentLayout!.tfWeight, isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight!.getValue())) {
            isValid = false
            viewToScroll = contentLayout!.tfWeight
        }
        if !Validate.isValidPicker(tfPicker: contentLayout!.tfCountry) {
            isValid = false
            viewToScroll = contentLayout!.tfCountry
        }
        if !Validate.isValidPicker(tfPicker: contentLayout!.tfGender) {
            isValid = false
            viewToScroll = contentLayout!.tfGender
        }
        if !Validate.isValidPicker(tfPicker: contentLayout!.tfArtOfPaddling) {
            isValid = false
            viewToScroll = contentLayout!.tfArtOfPaddling
        }
        if !Validate.isValidPicker(tfPicker: contentLayout!.tfUnitWeight) {
            isValid = false
            viewToScroll = contentLayout!.tfUnitWeight
        }
        if !Validate.isValidPicker(tfPicker: contentLayout!.tfUnitDistance) {
            isValid = false
            viewToScroll = contentLayout!.tfUnitDistance
        }
        if !Validate.isValidPicker(tfPicker: contentLayout!.tfUnitPace) {
            isValid = false
            viewToScroll = contentLayout!.tfUnitPace
        }

        if let scroll = viewToScroll {
            contentLayout!.scrollView!.scrollToView(view: scroll, animated: true)
        }
        
        return isValid
    }
    
    func resetDataFields() {
        contentLayout!.tfFirstName.text = ""
        contentLayout!.tfLastName.text = ""
        contentLayout!.tfUserName.text = ""
        contentLayout!.tfPassword.text = ""
        contentLayout!.tfEmail.text = ""
        contentLayout!.tfBirthDate.text = ""
        contentLayout!.tfClub.text = ""
        contentLayout!.tfWeight.text = ""
        contentLayout!.tfCountry.text = ""
        contentLayout!.tfGender.text = ""
        contentLayout!.tfArtOfPaddling.text = ""
        contentLayout!.tfUnitWeight.text = ""
        contentLayout!.tfUnitDistance.text = ""
        contentLayout!.tfUnitPace.text = ""
    }
}
