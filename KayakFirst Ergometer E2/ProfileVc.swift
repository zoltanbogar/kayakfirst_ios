//
//  ProfileVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class ProfileVc: MainTabVc {
    
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
            
            //TODO: move this to BaseVc
            self.contentLayout = getContentLayout(contentView: contentView)
            self.contentLayout?.setView()
            ///////////////////////////
            
            (contentLayout as! VcProfileLayout).tfPassword.clickCallback = {
                self.clickPassword()
            }
            (contentLayout as! VcProfileLayout).btnLogout.target = self
            (contentLayout as! VcProfileLayout).btnLogout.action = #selector(clickLogout)
            (contentLayout as! VcProfileLayout).btnSave.target = self
            (contentLayout as! VcProfileLayout).btnSave.action = #selector(btnSaveClick)
            (contentLayout as! VcProfileLayout).btnEdit.target = self
            (contentLayout as! VcProfileLayout).btnEdit.action = #selector(btnEditClick)
            
            countryPickerHelper = PickerHelperLocale(
                pickerView: (contentLayout as! VcProfileLayout).countryPickerView, textField: (contentLayout as! VcProfileLayout).tfCountry.valueTextField)
            genderPickerHelper = PickerHelperGender(
                pickerView: (contentLayout as! VcProfileLayout).genderPickerView, textField: (contentLayout as! VcProfileLayout).tfGender.valueTextField)
            artOfPaddlingPickerHelper = PickerHelperArtOfPaddling(
                pickerView: (contentLayout as! VcProfileLayout).artOfPaddlingPickerView, textField: (contentLayout as! VcProfileLayout).tfArtOfPaddling.valueTextField)
            pickerHelperUnitWeight = PickerHelperUnit(
                pickerView: (contentLayout as! VcProfileLayout).unitWeightPickerView, textField: (contentLayout as! VcProfileLayout).tfUnitWeight.valueTextField)
            pickerHelperUnitDistance = PickerHelperUnit(
                pickerView: (contentLayout as! VcProfileLayout).unitDistancePickerView, textField: (contentLayout as! VcProfileLayout).tfUnitDistance.valueTextField)
            pickerHelperUnitPace = PickerHelperUnit(
                pickerView: (contentLayout as! VcProfileLayout).unitPacePickerView, textField: (contentLayout as! VcProfileLayout).tfUnitPace.valueTextField)
            
            initUser()
        }
    }
    
    override func getContentLayout(contentView: UIView) -> VcProfileLayout {
        return VcProfileLayout(contentView: contentView)
    }
    
    private func checkUser() -> Bool {
        if userManager.getUser() == nil {
            (UIApplication.shared.delegate as! AppDelegate).initMainWindow()
            self.dismiss(animated: false, completion: nil)
            return false
        }
        return true
    }
    
    override func initTabBarItems() {
        if contentLayout != nil {
            setTabbarItem(tabbarItem: (contentLayout as! VcProfileLayout).btnEdit)
            activateFields(isActive: false)
            
            self.navigationItem.setLeftBarButtonItems([(contentLayout as! VcProfileLayout).btnLogout], animated: true)
            
            self.navigationController!.navigationBar.tintColor = Colors.colorAccent
            
            showLogoCenter(viewController: self)
        }
    }
    
    private func initUser() {
        (contentLayout as! VcProfileLayout).tfFirstName.text = self.userManager.getUser()?.firstName
        (contentLayout as! VcProfileLayout).tfLastName.text = self.userManager.getUser()?.lastName
        if self.userManager.getUser()?.birthDate != 0 {
            (contentLayout as! VcProfileLayout).tfBirthDate.text = DateFormatHelper.getDate(dateFormat: DateFormatHelper.dateFormat, timeIntervallSince1970: self.userManager.getUser()?.birthDate)
        }
        (contentLayout as! VcProfileLayout).tfClub.text = self.userManager.getUser()?.club
        (contentLayout as! VcProfileLayout).tfUserName.text = self.userManager.getUser()?.userName
        (contentLayout as! VcProfileLayout).tfEmail.text = self.userManager.getUser()?.email
        
        initBodyWeight(user: self.userManager.getUser())
        
        (contentLayout as! VcProfileLayout).tfCountry.text = NSLocale.getCountryNameByCode(countryCode: self.userManager.getUser()?.country)
        
        if let gender = self.userManager.getUser()?.gender {
            (contentLayout as! VcProfileLayout).tfGender.text = self.genderPickerHelper!.getTitle(value: gender)
        }
        
        if let artOfPaddling = self.userManager.getUser()?.artOfPaddling {
            (contentLayout as! VcProfileLayout).tfArtOfPaddling.text = self.artOfPaddlingPickerHelper!.getTitle(value: artOfPaddling)
        }
        if let unitWeight = self.userManager.getUser()?.unitWeight {
            (contentLayout as! VcProfileLayout).tfUnitWeight.text = self.pickerHelperUnitWeight!.getTitle(value: unitWeight)
        }
        if let unitDistance = self.userManager.getUser()?.unitDistance {
            (contentLayout as! VcProfileLayout).tfUnitDistance.text = self.pickerHelperUnitDistance!.getTitle(value: unitDistance)
        }
        if let unitPace = self.userManager.getUser()?.unitPace {
            (contentLayout as! VcProfileLayout).tfUnitPace.text = self.pickerHelperUnitPace!.getTitle(value: unitPace)
        }
    }
    
    private func initBodyWeight(user: User?) {
        if user != nil {
            bodyWeight = user!.bodyWeight!
            
            (contentLayout as! VcProfileLayout).tfWeight.text = String.init(format: "%.0f", UnitHelper.getWeightValue(value: bodyWeight))
            pickerHelperUnitWeight?.pickerChangedListener = pickerUnitWeightListener
            (contentLayout as! VcProfileLayout).tfWeight?.textChangedListener = bodyWeightChangedListener
            
            initBodyWeightUnit(isMetric: UnitHelper.isMetricWeight())
        }
    }
    
    private func initBodyWeightUnit(isMetric: Bool) {
        let title = (contentLayout as! VcProfileLayout).tfWeight.title!
        let splitText = title.components(separatedBy: "(")
        var originalTitle: String = splitText[0]
        
        let endWithSpace = originalTitle.hasSuffix(" ")
        
        originalTitle = originalTitle + (endWithSpace ? "" : " ") + "(" + UnitHelper.getWeightUnit(isMetric: isMetric) + ")"
        (contentLayout as! VcProfileLayout).tfWeight.title = originalTitle
    }
    
    private func bodyWeightChangedListener() {
        let value = (contentLayout as! VcProfileLayout).tfWeight.text
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
                lastName: (contentLayout as! VcProfileLayout).tfLastName.text,
                firstName: (contentLayout as! VcProfileLayout).tfFirstName.text,
                email: (contentLayout as! VcProfileLayout).tfEmail.text,
                bodyWeight: UnitHelper.getMetricWeightValue(value: bodyWeight, isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight?.getValue())),
                gender: self.userManager.getUser()?.gender,
                birthDate: self.userManager.getUser()?.birthDate,
                club: (contentLayout as! VcProfileLayout).tfClub.text,
                country: self.countryPickerHelper!.getValue() ?? userManager.getUser()?.country,
                artOfPaddling: self.artOfPaddlingPickerHelper!.getValue(),
                password: (contentLayout as! VcProfileLayout).tfPassword.text,
                userName: (contentLayout as! VcProfileLayout).tfUserName.text,
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
        setTabbarItem(tabbarItem: (contentLayout as! VcProfileLayout).btnSave)
    }
    
    private func setTabbarItem(tabbarItem: UIBarButtonItem?) {
        self.navigationItem.setRightBarButtonItems([tabbarItem!], animated: true)
    }
    
    private func activateFields(isActive: Bool) {
        (contentLayout as! VcProfileLayout).tfPassword.clickable = isActive
        (contentLayout as! VcProfileLayout).tfPassword.active = isActive
        (contentLayout as! VcProfileLayout).tfWeight.active = isActive
        (contentLayout as! VcProfileLayout).tfClub.active = isActive
        (contentLayout as! VcProfileLayout).tfCountry.active = isActive
        (contentLayout as! VcProfileLayout).tfArtOfPaddling.active = isActive
        (contentLayout as! VcProfileLayout).tfUnitWeight.active = isActive
        (contentLayout as! VcProfileLayout).tfUnitDistance.active = isActive
        (contentLayout as! VcProfileLayout).tfUnitPace.active = isActive
        
        if !isActive {
            initBodyWeight(user: self.userManager.getUser())
            
            (contentLayout as! VcProfileLayout).tfWeight.endEditing(true)
        }
    }
    
    private func checkRequiredElements() -> Bool {
        let isValidArtOfPaddling = Validate.isValidPicker(tfPicker: (contentLayout as! VcProfileLayout).tfArtOfPaddling)
        let isValidUnitWeight = Validate.isValidPicker(tfPicker: (contentLayout as! VcProfileLayout).tfUnitWeight)
        let isValidUnitDistance = Validate.isValidPicker(tfPicker: (contentLayout as! VcProfileLayout).tfUnitDistance)
        let isValidUnitPace = Validate.isValidPicker(tfPicker: (contentLayout as! VcProfileLayout).tfUnitPace)
        let isValidBodyWeight = Validate.isValidBodyWeight(tfWeight: (contentLayout as! VcProfileLayout).tfWeight, isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight?.getValue()))
        
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
        
        startWelcomeViewController(viewController: self)
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
