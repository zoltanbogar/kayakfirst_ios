//
//  ProfileVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class ProfileVc: MainTabVc, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: constants
    private let viewBottomHeight: CGFloat = buttonHeight + margin2
    
    //MARK: views
    private var stackView: UIStackView?
    private var progressView: ProgressView?
    private var scrollView: AppScrollView?
    private let countryPickerView = UIPickerView()
    private let artOfPaddlingPickerView = UIPickerView()
    
    //MARK: properties
    var userService = UserService.sharedInstance
    private var countryCode: String?
    private var artOfPaddling: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        countryPickerView.delegate = self
        artOfPaddlingPickerView.delegate = self
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
            
            progressView = ProgressView(superView: contentView)
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
        textField.text = self.userService.getUser()?.firstName
        
        return textField
    }()
    
    private lazy var tfLastName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_last_name")
        textField.active = false
        textField.text = self.userService.getUser()?.lastName
        
        return textField
    }()
    
    private lazy var tfBirthDate: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_birth_date")
        textField.active = false
        if self.userService.getUser()?.birthDate != 0 {
            textField.text = DateFormatHelper.getDate(dateFormat: getString("date_format"), timeIntervallSince1970: self.userService.getUser()?.birthDate)
        }
        
        return textField
    }()
    
    private lazy var tfClub: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_club")
        textField.active = false
        textField.text = self.userService.getUser()?.club
        
        return textField
    }()
    
    private lazy var tfUserName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_name")
        textField.active = false
        textField.text = self.userService.getUser()?.userName
        
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
        textField.text = self.userService.getUser()?.email
        
        return textField
    }()
    
    private lazy var tfWeight: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_weight")
        textField.active = false
        textField.keyBoardType = .numberPad
        
        let weight = self.userService.getUser()?.bodyWeight
        
        if let weightValue = weight {
            textField.text = "\(Int(weightValue))"
        }
        
        return textField
    }()
    
    private lazy var tfCountry: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_country")
        textField.active = false
        textField.text = NSLocale.getCountryNameByCode(countryCode: self.userService.getUser()?.country)
        
        textField.valueTextField.inputView = self.countryPickerView
        
        return textField
    }()
    
    private lazy var tfGender: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_gender")
        textField.active = false
        
        if let gender = self.userService.getUser()?.gender {
            if gender == User.genderFemale {
                textField.text = getString("user_gender_female")
            } else {
                textField.text = getString("user_gender_male")
            }
        }
        
        return textField
    }()
    
    private lazy var tfArtOfPaddling: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_art_of_paddling")
        textField.active = false
        
        textField.valueTextField.inputView = self.artOfPaddlingPickerView
        
        //TODO: refactor this
        if let artOfPaddling = self.userService.getUser()?.artOfPaddling {
            switch artOfPaddling {
            case User.artOfPaddlingRacingKayaking:
                textField.text = getString("user_art_of_paddling_racing_kayaking")
            case User.artOfPaddlingRacingCanoeing:
                textField.text = getString("user_art_of_paddling_racing_canoeing")
            case  User.artOfPaddlingRecreationalKayaking:
                textField.text = getString("user_art_of_paddling_recreational_kayaking")
            case User.artOfPaddlingRecreationalCanoeing:
                textField.text = getString("user_art_of_paddling_recreational_canoeing")
            case User.artOfPaddlingSup:
                textField.text = getString("user_art_of_paddling_sup")
            case User.artOfPaddlingDragon:
                textField.text = getString("user_art_of_paddling_dragon")
            case User.artOfPaddlingRowing:
                textField.text = getString("user_art_of_paddling_rowing")
            default:
                break
            }
        }
        
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
        if checkBodyWeight() {
            progressView?.show(true)
            UserService.sharedInstance.updateUser(userDataCallBack: self.userDataCallback,
                userDto: UserDto(
                                lastName: tfLastName.text,
                                firstName: tfFirstName.text,
                                email: tfEmail.text,
                                bodyWeight: Double(tfWeight.text!),
                                gender: self.userService.getUser()?.gender,
                                birthDate: self.userService.getUser()?.birthDate,
                                club: tfClub.text,
                                country: countryCode,
                                artOfPaddling: self.artOfPaddling,
                                password: tfPassword.text,
                                userName: tfUserName.text))
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
        
        if !isActive {
            let weight = self.userService.getUser()?.bodyWeight
            
            if let weightValue = weight {
                tfWeight.text = "\(Int(weightValue))"
            }
            tfWeight.endEditing(true)
        }
    }
    
    private func checkBodyWeight() -> Bool {
        let bodyWeight: Int = tfWeight.text == nil || tfWeight.text == "" ? 0 : Int(tfWeight.text!)!
        if bodyWeight < User.minBodyWeight {
            tfWeight.error = getString("error_weight")
            return false
        }
        return true
    }
    
    //MARK: pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return NSLocale.locales().count
        } else {
            return User.artOfPaddlingOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPickerView {
            return NSLocale.locales()[row].countryName
        } else {
            return User.artOfPaddlingOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPickerView {
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
