//
//  ProfileVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class ProfileVc: BaseVC<VcProfileLayout> {
    
    //MARK: constants
    private let viewBottomHeight: CGFloat = buttonHeight + margin2
    
    private var countryPickerHelper: PickerHelperLocale?
    private var genderPickerHelper: PickerHelperGender?
    private var artOfPaddlingPickerHelper: PickerHelperArtOfPaddling?
    private var pickerHelperUnitWeight: PickerHelperUnit?
    private var pickerHelperUnitDistance: PickerHelperUnit?
    private var pickerHelperUnitPace: PickerHelperUnit?
    
    //MARK: properties
    var userManager = UserManager.sharedInstance
    
    private var bodyWeight: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.logoutCallback = logoutCallback
        userManager.updatePwCallback = updatePasswordCallback
        userManager.updateUserCallback = updateUserCallback
    }
    
    //MARK: init view
    internal override func initView() {
        if checkUser() {
            super.initView()
            
            contentLayout!.tfPassword.clickCallback = {
                self.clickPassword()
            }
            contentLayout!.btnLogout.target = self
            contentLayout!.btnLogout.action = #selector(clickLogout)
            contentLayout!.btnSave.target = self
            contentLayout!.btnSave.action = #selector(btnSaveClick)
            contentLayout!.btnEdit.target = self
            contentLayout!.btnEdit.action = #selector(btnEditClick)
            
            countryPickerHelper = PickerHelperLocale(
                pickerView: contentLayout!.countryPickerView, textField: contentLayout!.tfCountry.contentLayout!.valueTextField)
            genderPickerHelper = PickerHelperGender(
                pickerView: contentLayout!.genderPickerView, textField: contentLayout!.tfGender.contentLayout!.valueTextField)
            artOfPaddlingPickerHelper = PickerHelperArtOfPaddling(
                pickerView: contentLayout!.artOfPaddlingPickerView, textField: contentLayout!.tfArtOfPaddling.contentLayout!.valueTextField)
            pickerHelperUnitWeight = PickerHelperUnit(
                pickerView: contentLayout!.unitWeightPickerView, textField: contentLayout!.tfUnitWeight.contentLayout!.valueTextField)
            pickerHelperUnitDistance = PickerHelperUnit(
                pickerView: contentLayout!.unitDistancePickerView, textField: contentLayout!.tfUnitDistance.contentLayout!.valueTextField)
            pickerHelperUnitPace = PickerHelperUnit(
                pickerView: contentLayout!.unitPacePickerView, textField: contentLayout!.tfUnitPace.contentLayout!.valueTextField)
            
            initUser()
        }
    }
    
    override func getContentLayout(contentView: UIView) -> VcProfileLayout {
        return VcProfileLayout(contentView: contentView)
    }
    
    private func checkUser() -> Bool {
        if userManager.getUser() == nil {
            userManager.isQuickStart = false
            (UIApplication.shared.delegate as! AppDelegate).startMainWindow()
            return false
        }
        return true
    }
    
    override func initTabBarItems() {
        if contentLayout != nil {
            setTabbarItem(tabbarItem: contentLayout!.btnEdit)
            activateFields(isActive: false)
            
            self.navigationItem.setLeftBarButtonItems([contentLayout!.btnLogout], animated: true)
            
            self.navigationController!.navigationBar.tintColor = Colors.colorAccent
            
            showLogoCenter(viewController: self)
        }
    }
    
    private func initUser() {
        contentLayout!.tfFirstName.text = self.userManager.getUser()?.firstName
        contentLayout!.tfLastName.text = self.userManager.getUser()?.lastName
        if self.userManager.getUser()?.birthDate != 0 {
            contentLayout!.tfBirthDate.text = DateFormatHelper.getDate(dateFormat: DateFormatHelper.dateFormat, timeIntervallSince1970: self.userManager.getUser()?.birthDate)
        }
        contentLayout!.tfClub.text = self.userManager.getUser()?.club
        contentLayout!.tfUserName.text = self.userManager.getUser()?.userName
        contentLayout!.tfEmail.text = self.userManager.getUser()?.email
        
        initBodyWeight(user: self.userManager.getUser())
        
        contentLayout!.tfCountry.text = NSLocale.getCountryNameByCode(countryCode: self.userManager.getUser()?.country)
        
        if let gender = self.userManager.getUser()?.gender {
            contentLayout!.tfGender.text = self.genderPickerHelper!.getTitle(value: gender)
        }
        
        if let artOfPaddling = self.userManager.getUser()?.artOfPaddling {
            contentLayout!.tfArtOfPaddling.text = self.artOfPaddlingPickerHelper!.getTitle(value: artOfPaddling)
        }
        if let unitWeight = self.userManager.getUser()?.unitWeight {
            contentLayout!.tfUnitWeight.text = self.pickerHelperUnitWeight!.getTitle(value: unitWeight)
        }
        if let unitDistance = self.userManager.getUser()?.unitDistance {
            contentLayout!.tfUnitDistance.text = self.pickerHelperUnitDistance!.getTitle(value: unitDistance)
        }
        if let unitPace = self.userManager.getUser()?.unitPace {
            contentLayout!.tfUnitPace.text = self.pickerHelperUnitPace!.getTitle(value: unitPace)
        }
    }
    
    private func initBodyWeight(user: User?) {
        if user != nil {
            bodyWeight = user!.bodyWeight!
            
            contentLayout!.tfWeight.text = String.init(format: "%.0f", UnitHelper.getWeightValue(value: bodyWeight))
            pickerHelperUnitWeight?.pickerChangedListener = pickerUnitWeightListener
            contentLayout!.tfWeight?.textChangedListener = bodyWeightChangedListener
            
            initBodyWeightUnit(isMetric: UnitHelper.isMetricWeight())
        }
    }
    
    private func initBodyWeightUnit(isMetric: Bool) {
        let title = contentLayout!.tfWeight.title!
        let splitText = title.components(separatedBy: "(")
        var originalTitle: String = splitText[0]
        
        let endWithSpace = originalTitle.hasSuffix(" ")
        
        originalTitle = originalTitle + (endWithSpace ? "" : " ") + "(" + UnitHelper.getWeightUnit(isMetric: isMetric) + ")"
        contentLayout!.tfWeight.title = originalTitle
    }
    
    private func bodyWeightChangedListener() {
        let value = contentLayout!.tfWeight.text
        if value != nil && "" != value {
            bodyWeight = Double(value!)!
        }
    }
    
    private func pickerUnitWeightListener() {
        initBodyWeightUnit(isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight!.getValue()))
    }
    
    //MARK: callbacks
    @objc private func btnSaveClick() {
        if checkRequiredElements() {
            
            let managerType = userManager.update(userDto: UserDto(
                lastName: contentLayout!.tfLastName.text,
                firstName: contentLayout!.tfFirstName.text,
                email: contentLayout!.tfEmail.text,
                bodyWeight: UnitHelper.getMetricWeightValue(value: bodyWeight, isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight?.getValue())),
                gender: self.userManager.getUser()?.gender,
                birthDate: self.userManager.getUser()?.birthDate,
                club: contentLayout!.tfClub.text,
                country: self.countryPickerHelper!.getValue() ?? userManager.getUser()?.country,
                artOfPaddling: self.artOfPaddlingPickerHelper!.getValue(),
                password: contentLayout!.tfPassword.text,
                userName: contentLayout!.tfUserName.text,
                unitWeight: pickerHelperUnitWeight?.getValue(),
                unitDistance: pickerHelperUnitDistance?.getValue(),
                unitPace: pickerHelperUnitPace?.getValue(),
                googleId: nil,
                facebookId: nil))
            showProgress(baseManagerType: managerType)
        }
    }
    
    @objc private func btnEditClick() {
        activateFields(isActive: true)
        setTabbarItem(tabbarItem: contentLayout!.btnSave)
    }
    
    private func setTabbarItem(tabbarItem: UIBarButtonItem?) {
        self.navigationItem.setRightBarButtonItems([tabbarItem!], animated: true)
    }
    
    private func activateFields(isActive: Bool) {
        contentLayout!.tfPassword.clickable = isActive
        contentLayout!.tfPassword.active = isActive
        contentLayout!.tfWeight.active = isActive
        contentLayout!.tfClub.active = isActive
        contentLayout!.tfCountry.active = isActive
        contentLayout!.tfArtOfPaddling.active = isActive
        contentLayout!.tfUnitWeight.active = isActive
        contentLayout!.tfUnitDistance.active = isActive
        contentLayout!.tfUnitPace.active = isActive
        
        if !isActive {
            initBodyWeight(user: self.userManager.getUser())
            
            contentLayout!.tfWeight.endEditing(true)
        }
    }
    
    private func checkRequiredElements() -> Bool {
        let isValidArtOfPaddling = Validate.isValidPicker(tfPicker: contentLayout!.tfArtOfPaddling)
        let isValidUnitWeight = Validate.isValidPicker(tfPicker: contentLayout!.tfUnitWeight)
        let isValidUnitDistance = Validate.isValidPicker(tfPicker: contentLayout!.tfUnitDistance)
        let isValidUnitPace = Validate.isValidPicker(tfPicker: contentLayout!.tfUnitPace)
        let isValidBodyWeight = Validate.isValidBodyWeight(tfWeight: contentLayout!.tfWeight, isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight?.getValue()))
        
        return isValidArtOfPaddling && isValidUnitWeight && isValidUnitDistance && isValidUnitPace && isValidBodyWeight
    }
    
    @objc private func clickLogout() {
        let manager = userManager.logout()
        showProgress(baseManagerType: manager)
    }
    
    private func clickPassword() {
        let passworDialog = NewPasswordDialog()
        passworDialog.handler = { currentPassword, newPassword in
            let manager = self.userManager.updatePassword(currentPassword: currentPassword, newPassword: newPassword)
            self.showProgress(baseManagerType: manager)
        }
        passworDialog.show(viewController: self)
    }
    
    //MARK: manager callbacks
    private func logoutCallback(data: Bool?, error: Responses?) {
        dismissProgress()
        
        (UIApplication.shared.delegate as! AppDelegate).startMainWindow()
    }
    
    private func updateUserCallback(data: User?, error: Responses?) {
        handleUpdate(error: error)
    }
    
    private func updatePasswordCallback(data: Bool?, error: Responses?) {
        handleUpdate(error: error)
    }
    
    private func handleUpdate(error: Responses?) {
        dismissProgress()
        
        if error == nil {
            initTabBarItems()
        } else {
            errorHandlingWithAlert(viewController: self, error: error!)
        }
    }
    
}
