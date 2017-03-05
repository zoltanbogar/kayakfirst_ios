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
    private let stackView = UIStackView()
    private var progressView: ProgressView?
    private var scrollView: AppScrollView?
    
    //MARK: properties
    var userService = UserService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    //MARK: init view
    internal override func initView() {
        scrollView = AppScrollView(view: contentView)
        stackView.axis = .vertical
        stackView.spacing = margin05
        
        scrollView!.addSubview(imgProfile)
        imgProfile.snp.makeConstraints { (make) in
            make.centerX.equalTo(scrollView!.containerView)
            make.top.equalTo(scrollView!.containerView).inset(UIEdgeInsetsMake(margin, 0, 0, 0))
        }
        
        scrollView!.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imgProfile.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin, 0))
            make.left.equalTo(scrollView!.containerView)
            make.right.equalTo(scrollView!.containerView)
            make.bottom.equalTo(scrollView!.containerView)
        }
        
        stackView.addArrangedSubview(tfFirstName)
        stackView.addArrangedSubview(tfLastName)
        stackView.addArrangedSubview(tfBirthDate)
        stackView.addArrangedSubview(tfUserName)
        stackView.addArrangedSubview(tfPassword)
        stackView.addArrangedSubview(tfEmail)
        stackView.addArrangedSubview(tfWeight)
        stackView.addArrangedSubview(tfCountry)
        stackView.addArrangedSubview(tfGender)
        
        progressView = ProgressView(superView: contentView)
    }
    
    override func initTabBarItems() {
        setTabbarItem(tabbarItem: btnEdit)
        activateFields(isActive: false)
        
        self.navigationItem.setLeftBarButtonItems([btnLogout], animated: true)
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
        textField.text = "\(Int((self.userService.getUser()?.bodyWeight)!))"
        
        return textField
    }()
    
    //TODO: country is editable
    //TODO: add 'Club'
    private lazy var tfCountry: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_country")
        textField.active = false
        textField.text = NSLocale.getCountryNameByCode(countryCode: self.userService.getUser()?.country)
        
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
                                                    country: self.userService.getUser()?.country,
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
        
        if !isActive {
            tfWeight.text = "\(Int((self.userService.getUser()?.bodyWeight)!))"
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
