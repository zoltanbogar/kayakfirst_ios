//
//  VcProfileLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 28..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcProfileLayout: BaseLayout {
    
    var stackView: UIStackView?
    var progressView: ProgressView?
    var scrollView: AppScrollView?
    
    let countryPickerView = UIPickerView()
    let genderPickerView = UIPickerView()
    let artOfPaddlingPickerView = UIPickerView()
    let unitWeightPickerView = UIPickerView()
    let unitDistancePickerView = UIPickerView()
    let unitPacePickerView = UIPickerView()
    
    override func setView() {
        scrollView = AppScrollView(view: contentView)
        stackView = UIStackView()
        stackView?.axis = .vertical
        stackView?.spacing = margin
        
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
    }
    
    //MARK: views
    lazy var imgProfile: UIImageView! = {
        let imageView = UIImageView()
        let image = UIImage(named: "profile_image")
        imageView.image = image
        
        return imageView
    }()
    
    lazy var tfFirstName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_first_name")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfLastName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_last_name")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfBirthDate: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_birth_date")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfClub: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_club")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfUserName: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_name")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfPassword: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_password")
        textField.secureTextEntry = true
        textField.active = false
        
        return textField
    }()
    
    lazy var tfEmail: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_email")
        textField.keyBoardType = .emailAddress
        textField.active = false
        
        return textField
    }()
    
    lazy var tfWeight: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_weight")
        textField.active = false
        textField.keyBoardType = .numberPad
        
        return textField
    }()
    
    lazy var tfCountry: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_country")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfGender: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_gender")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfArtOfPaddling: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("user_art_of_paddling")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfUnitWeight: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("unit_weight")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfUnitDistance: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("unit_distance")
        textField.active = false
        
        return textField
    }()
    
    lazy var tfUnitPace: ProfileElement! = {
        let textField = ProfileElement()
        textField.title = getString("unit_pace")
        textField.active = false
        
        return textField
    }()
    
    //MARK: tabbar items
    lazy var btnLogout: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.title = getString("user_log_out")
        
        return button
    }()
    
    lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "done_24dp")?.withRenderingMode(.alwaysOriginal)
        
        return button
    }()
    
    lazy var btnEdit: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal)
        
        return button
    }()
    
}
