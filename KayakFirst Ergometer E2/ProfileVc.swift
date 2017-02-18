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
    var user = UserService.sharedInstance.getUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    internal override func initView() {
        scrollView = AppScrollView(view: contentView)
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
        
        stackView.addVerticalSpacing(spacing: viewBottomHeight)
        
        let viewBottom = UIView()
        viewBottom.backgroundColor = Colors.colorPrimary
        contentView.addSubview(viewBottom)
        viewBottom.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.equalTo(stackView.snp.left)
            make.width.equalTo(stackView.snp.width)
            make.height.equalTo(viewBottomHeight)
        }
        
        viewBottom.addSubview(btnLogout)
        btnLogout.snp.makeConstraints { make in
            make.width.equalTo(viewBottom.snp.width)
            make.left.equalTo(viewBottom.snp.left)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(viewBottom.snp.bottom).inset(UIEdgeInsetsMake(0, 0, margin, 0))
        }
        progressView = ProgressView(superView: contentView)
    }
    
    override func initTabBarItems() {
        self.tabBarController?.navigationItem.setRightBarButtonItems([btnSave], animated: true)
    }
    
    private lazy var tfFirstName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_first_name")
        textField.active = false
        textField.text = self.user?.firstName
        
        return textField
    }()
    
    private lazy var tfLastName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_last_name")
        textField.active = false
        textField.text = self.user?.lastName
        
        return textField
    }()
    
    private lazy var tfBirthDate: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_birth_date")
        textField.isEditable = false
        textField.active = false
        if self.user?.birthDate != 0 {
            textField.text = DateFormatHelper.getDate(dateFormat: getString("date_format"), timeIntervallSince1970: self.user?.birthDate)
        }
        
        return textField
    }()
    
    private lazy var tfUserName: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_name")
        textField.required = true
        textField.active = false
        textField.text = self.user?.userName
        
        return textField
    }()
    
    private lazy var tfPassword: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_password")
        textField.secureTextEntry = true
        textField.required = true
        textField.isEditable = false
        textField.clickCallback = {
            self.clickPassword()
        }
        
        return textField
    }()
    
    private lazy var tfEmail: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_email")
        textField.keyBoardType = .emailAddress
        textField.required = true
        textField.active = false
        textField.text = self.user?.email
        
        return textField
    }()
    
    private lazy var tfWeight: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_weight")
        textField.keyBoardType = .numberPad
        textField.required = true
        textField.text = "\(Int((self.user?.bodyWeight)!))"
        
        return textField
    }()
    
    private lazy var tfCountry: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_country")
        textField.required = true
        textField.active = false
        textField.text = NSLocale.getCountryNameByCode(countryCode: self.user?.country)
        
        return textField
    }()
    
    private lazy var tfGender: DialogElementTextField! = {
        let textField = DialogElementTextField(frame: CGRect.zero)
        textField.title = getString("user_gender")
        textField.required = true
        textField.active = false
        
        if let gender = self.user?.gender {
            if gender == User.genderFemale {
                textField.text = getString("user_gender_female")
            } else {
                textField.text = getString("user_gender_male")
            }
        }
        
        return textField
    }()
    
    private lazy var btnLogout: AppUIButton! = {
        let button = AppUIButton(width: 0, height: 0, text: getString("user_log_out"), backgroundColor: Colors.colorWhite, textColor: Colors.colorAccent)
        button.addTarget(self, action: #selector(clickLogout), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "done_24dp")
        button.target = self
        button.action = #selector(btnSaveClick)
        
        return button
    }()
    
    @objc private func btnSaveClick() {
        if checkBodyWeight() {
            progressView?.show(true)
            UserService.sharedInstance.updateUser(userDataCallBack: self.userDataCallback,
                                                  userDto: UserDto(
                                                    lastName: tfLastName.text,
                                                    firstName: tfFirstName.text,
                                                    email: tfEmail.text,
                                                    bodyWeight: Double(tfWeight.text!),
                                                    gender: user?.gender,
                                                    birthDate: user?.birthDate,
                                                    country: user?.country,
                                                    password: tfPassword.text,
                                                    userName: tfUserName.text))
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
        UserService.sharedInstance.logout(userDataCallBack: logoutCallback)
    }
    
    private func logoutCallback(error: Responses?, userData: Bool?) {
        self.progressView?.show(false)
        
        if let user = userData {
            showWelcomeViewController()
        } else if let userError = error {
            AppService.errorHandlingWithAlert(viewController: self, error: userError)
        }
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
        } else if let userError = error {
            AppService.errorHandlingWithAlert(viewController: self, error: userError)
        }
    }
    
    private func showWelcomeViewController() {
        let controller = WelcomeViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
}
