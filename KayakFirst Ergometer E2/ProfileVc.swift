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
    
    //MARK: views
    private var stackView: UIStackView?
    private var progressView: ProgressView?
    private var scrollView: AppScrollView?
    
    private let countryPickerView = UIPickerView()
    private var countryPickerHelper: PickerHelperLocale?
    private let genderPickerView = UIPickerView()
    private var genderPickerHelper: PickerHelperGender?
    private let artOfPaddlingPickerView = UIPickerView()
    private var artOfPaddlingPickerHelper: PickerHelperArtOfPaddling?
    private let unitWeightPickerView = UIPickerView()
    private var pickerHelperUnitWeight: PickerHelperUnit?
    private let unitDistancePickerView = UIPickerView()
    private var pickerHelperUnitDistance: PickerHelperUnit?
    private let unitPacePickerView = UIPickerView()
    private var pickerHelperUnitPace: PickerHelperUnit?
    
    //MARK: properties
    var userService = UserService.sharedInstance
    
    override func viewDidLoad() {
        countryPickerHelper = PickerHelperLocale(pickerView: countryPickerView, textField: tfCountry.valueTextField)
        genderPickerHelper = PickerHelperGender(pickerView: genderPickerView, textField: tfGender.valueTextField)
        artOfPaddlingPickerHelper = PickerHelperArtOfPaddling(pickerView: artOfPaddlingPickerView, textField: tfArtOfPaddling.valueTextField)
        pickerHelperUnitWeight = PickerHelperUnit(pickerView: unitWeightPickerView, textField: tfUnitWeight.valueTextField)
        pickerHelperUnitDistance = PickerHelperUnit(pickerView: unitDistancePickerView, textField: tfUnitDistance.valueTextField)
        pickerHelperUnitPace = PickerHelperUnit(pickerView: unitPacePickerView, textField: tfUnitPace.valueTextField)
        
        super.viewDidLoad()
        
        initView()
    }
    
    //MARK: init view
    internal override func initView() {
        if checkUser() {
            scrollView = AppScrollView(view: contentView)
            stackView = UIStackView()
            stackView?.axis = .vertical
            stackView?.spacing = margin05
            
            scrollView!.addSubview(imgProfile)
            imgProfile.snp.makeConstraints { (make) in
                make.centerX.equalTo(scrollView!.containerView)
                make.top.equalTo(scrollView!.containerView).inset(UIEdgeInsetsMake(margin, 0, 0, 0))
            }
            
            scrollView!.addSubview(stackView!)
            stackView?.snp.makeConstraints { make in
                make.top.equalTo(imgProfile.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin, 0))
                make.left.equalTo(scrollView!.containerView)
                make.right.equalTo(scrollView!.containerView)
                make.bottom.equalTo(scrollView!.containerView)
            }
            
            stackView?.addArrangedSubview(tfFirstName)
            stackView?.addArrangedSubview(tfLastName)
            stackView?.addArrangedSubview(tfBirthDate)
            stackView?.addArrangedSubview(tfClub)
            stackView?.addArrangedSubview(tfUserName)
            stackView?.addArrangedSubview(tfPassword)
            stackView?.addArrangedSubview(tfEmail)
            stackView?.addArrangedSubview(tfWeight)
            stackView?.addArrangedSubview(tfCountry)
            stackView?.addArrangedSubview(tfGender)
            stackView?.addArrangedSubview(tfArtOfPaddling)
            stackView?.addArrangedSubview(tfUnitWeight)
            stackView?.addArrangedSubview(tfUnitDistance)
            stackView?.addArrangedSubview(tfUnitPace)
            
            progressView = ProgressView(superView: contentView)
            
            initUser()
        }
    }
    
    private func checkUser() -> Bool {
        if userService.getUser() == nil {
            (UIApplication.shared.delegate as! AppDelegate).initMainWindow()
            self.dismiss(animated: false, completion: nil)
            return false
        }
        return true
    }
    
    override func initTabBarItems() {
        setTabbarItem(tabbarItem: btnEdit)
        activateFields(isActive: false)
        
        self.navigationItem.setLeftBarButtonItems([btnLogout], animated: true)
        
        showLogoCenter(viewController: self)
    }
    
    private func initUser() {
        tfFirstName.text = self.userService.getUser()?.firstName
        tfLastName.text = self.userService.getUser()?.lastName
        if self.userService.getUser()?.birthDate != 0 {
            tfBirthDate.text = DateFormatHelper.getDate(dateFormat: DateFormatHelper.dateFormat, timeIntervallSince1970: self.userService.getUser()?.birthDate)
        }
        tfClub.text = self.userService.getUser()?.club
        tfUserName.text = self.userService.getUser()?.userName
        tfEmail.text = self.userService.getUser()?.email
        
        initBodyWeight(user: self.userService.getUser())
        
        tfCountry.text = NSLocale.getCountryNameByCode(countryCode: self.userService.getUser()?.country)
        
        if let gender = self.userService.getUser()?.gender {
            tfGender.text = self.genderPickerHelper!.getTitle(value: gender)
        }
        
        if let artOfPaddling = self.userService.getUser()?.artOfPaddling {
            tfArtOfPaddling.text = self.artOfPaddlingPickerHelper!.getTitle(value: artOfPaddling)
        }
        if let unitWeight = self.userService.getUser()?.unitWeight {
            tfUnitWeight.text = self.pickerHelperUnitWeight!.getTitle(value: unitWeight)
        }
        if let unitDistance = self.userService.getUser()?.unitDistance {
            tfUnitDistance.text = self.pickerHelperUnitDistance!.getTitle(value: unitDistance)
        }
        if let unitPace = self.userService.getUser()?.unitPace {
            tfUnitPace.text = self.pickerHelperUnitPace!.getTitle(value: unitPace)
        }
    }
    
    private func initBodyWeight(user: User?) {
        let weight = user?.bodyWeight
        if let weightValue = weight {
            tfWeight.text = String.init(format: "%.1f", weightValue)
        }
        pickerHelperUnitWeight?.pickerChangedListener = pickerUnitWeightListener
        
        initBodyWeightUnit(isMetric: UnitHelper.isMetricWeight())
    }
    
    private func initBodyWeightUnit(isMetric: Bool) {
        let title = tfWeight.title!
        let splitText = title.components(separatedBy: "(")
        var originalTitle: String = splitText[0]
        
        let endWithSpace = originalTitle.hasSuffix(" ")
        
        originalTitle = originalTitle + (endWithSpace ? "" : " ") + "(" + UnitHelper.getWeightUnit(isMetric: isMetric) + ")"
        tfWeight.title = originalTitle
    }
    
    private func pickerUnitWeightListener() {
        initBodyWeightUnit(isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight!.getValue()))
    }
    
    //MARK: views
    private lazy var imgProfile: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "profile_image")
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var tfFirstName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_first_name")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfLastName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_last_name")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfBirthDate: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_birth_date")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfClub: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_club")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfUserName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_name")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfPassword: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_password")
        textField.secureTextEntry = true
        textField.active = false
        textField.clickCallback = {
            self.clickPassword()
        }
        
        return textField
    }()
    
    private lazy var tfEmail: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_email")
        textField.keyBoardType = .emailAddress
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfWeight: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_weight")
        textField.active = false
        textField.keyBoardType = .numberPad
        
        return textField
    }()
    
    private lazy var tfCountry: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_country")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfGender: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_gender")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfArtOfPaddling: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_art_of_paddling")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfUnitWeight: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("unit_weight")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfUnitDistance: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("unit_distance")
        textField.active = false
        
        return textField
    }()
    
    private lazy var tfUnitPace: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("unit_pace")
        textField.active = false
        
        return textField
    }()
    
    private lazy var btnLogout: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.title = getString("user_log_out")
        button.target = self
        button.action = #selector(clickLogout)
        
        return button
    }()
    
    private lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "done_24dp")
        button.target = self
        button.action = #selector(btnSaveClick)
        
        return button
    }()
    
    private lazy var btnEdit: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "edit")
        button.target = self
        button.action = #selector(btnEditClick)
        
        return button
    }()
    
    //MARK: callbacks
    @objc private func btnSaveClick() {
        if checkRequiredElements() {
            progressView?.show(true)
            UserService.sharedInstance.updateUser(userDataCallBack: self.userDataCallback,
                userDto: UserDto(
                                lastName: tfLastName.text,
                                firstName: tfFirstName.text,
                                email: tfEmail.text,
                                bodyWeight: UnitHelper.getMetricWeightValue(value: Double(tfWeight.text!)!, isMetric: UnitHelper.isMetric(keyUnit: pickerHelperUnitWeight?.getValue())),
                                gender: self.userService.getUser()?.gender,
                                birthDate: self.userService.getUser()?.birthDate,
                                club: tfClub.text,
                                country: self.countryPickerHelper!.getValue() ?? userService.getUser()?.country,
                                artOfPaddling: self.artOfPaddlingPickerHelper!.getValue(),
                                password: tfPassword.text,
                                userName: tfUserName.text,
                                unitWeight: pickerHelperUnitWeight?.getValue(),
                                unitDistance: pickerHelperUnitDistance?.getValue(),
                                unitPace: pickerHelperUnitPace?.getValue(),
                                googleId: nil,
                                facebookId: nil))
        }
    }
    
    @objc private func btnEditClick() {
        activateFields(isActive: true)
        setTabbarItem(tabbarItem: btnSave)
    }
    
    private func setTabbarItem(tabbarItem: UIBarButtonItem) {
        self.navigationItem.setRightBarButtonItems([tabbarItem], animated: true)
    }
    
    private func activateFields(isActive: Bool) {
        tfPassword.clickable = isActive
        tfPassword.active = isActive
        tfWeight.active = isActive
        tfClub.active = isActive
        tfCountry.active = isActive
        tfArtOfPaddling.active = isActive
        tfUnitWeight.active = isActive
        tfUnitDistance.active = isActive
        tfUnitPace.active = isActive
        
        if !isActive {
            initBodyWeight(user: self.userService.getUser())
            
            tfWeight.endEditing(true)
        }
    }
    
    private func checkRequiredElements() -> Bool {
        let isValidArtOfPaddling = Validate.isValidPicker(tfPicker: tfArtOfPaddling)
        let isValidUnitWeight = Validate.isValidPicker(tfPicker: tfUnitWeight)
        let isValidUnitDistance = Validate.isValidPicker(tfPicker: tfUnitDistance)
        let isValidUnitPace = Validate.isValidPicker(tfPicker: tfUnitPace)
        let isValidBodyWeight = Validate.isValidBodyWeight(tfWeight: tfWeight)
        
        return isValidArtOfPaddling && isValidUnitWeight && isValidUnitDistance && isValidUnitPace && isValidBodyWeight
    }
    
    @objc private func clickLogout() {
        progressView?.show(true)
        (UIApplication.shared.delegate as! AppDelegate).logoutSocial()
        UserService.sharedInstance.logout(userDataCallBack: logoutCallback)
    }
    
    private func logoutCallback(error: Responses?, userData: Bool?) {
        self.progressView?.show(false)
        
        UserService.sharedInstance.addLoginDto(loginDto: nil)
        showWelcomeViewController()
    }
    
    private func clickPassword() {
        let passworDialog = NewPasswordDialog()
        passworDialog.handler = { currentPassword, newPassword in
            self.progressView?.show(true)
            UserService.sharedInstance.updatePassword(userDataCallBack: self.userDataCallback, currentPassword: currentPassword, newPassword: newPassword)
        }
        passworDialog.show(viewController: self)
    }
    
    private func userDataCallback(error: Responses?, userData: User?) {
        self.progressView?.show(false)
        
        if let user = userData {
            self.navigationController?.popViewController(animated: true)
            initTabBarItems()
        } else if let userError = error {
            AppService.errorHandlingWithAlert(viewController: self, error: userError)
        }
    }
    
    private func showWelcomeViewController() {
        let controller = WelcomeViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
}
