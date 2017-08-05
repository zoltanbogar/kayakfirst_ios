//
//  LocationPermittionVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

func startLocationPermissionVc(viewController: UIViewController, trainingEnvType: TrainingEnvironmentType) -> UIViewController {
    let navController = UINavigationController()
    let permissionVc = LocationPermissionVc()
    permissionVc.trainingEnvType = trainingEnvType
    navController.pushViewController(permissionVc, animated: false)
    viewController.present(navController, animated: true, completion: nil)
    
    return navController
}

class LocationPermissionVc: BaseVC {
    
    //MARK: properties
    var trainingEnvType: TrainingEnvironmentType?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initEnvType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationPermission()
    }
    
    //MARK: functions
    private func checkLocationPermission() {
        if PermissionCheck.hasLocationPermission() {
            btnCloseClick()
        }
    }
    
    //MARK: functions
    private func initEnvType() {
        var iconColor: UIColor?
        var icon: UIImage?
        var text: String?
        
        if let envType = trainingEnvType {
            switch envType {
            case TrainingEnvironmentType.ergometer:
                iconColor = Colors.colorBluetooth
                icon = UIImage(named: "ic_bluetooth_white_48pt")!
                text = getString("fragment_bluetooth_location_permission_ios")
                break
            case TrainingEnvironmentType.outdoor:
                iconColor = Colors.colorAccent
                icon = UIImage(named: "ic_location_on_white_48pt")!
                text = getString("permission_location_ios")
            default:
                break
            }
            
            imgLocationIcon.image = icon
            imgLocationIcon.color = iconColor!
            label.text = text
        }
    }
    
    //MARK: init view
    override func initView() {
        view.addSubview(imgLocationIcon)
        view.addSubview(label)
        view.addSubview(btnSetting)
        
        imgLocationIcon.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imgLocationIcon.snp.bottom).offset(margin)
            make.centerX.equalTo(view)
            make.width.equalTo(view)
        }
        btnSetting.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-margin)
            make.width.equalTo(view).inset(UIEdgeInsetsMake(0, margin2, 0, margin2))
            make.centerX.equalTo(view)
        }
    }
    
    override func initTabBarItems() {
        showLogoOnRight()
        showCloseButton()
    }
    
    //MARK: views
    private lazy var imgLocationIcon: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_location_on_white_48pt")!, color: Colors.colorAccent)
        
        return button
    }()
    
    private lazy var label: UILabel! = {
        let label = AppUILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = getString("permission_location_ios")
        
        return label
    }()
    
    private lazy var btnSetting: AppUIButton! = {
        let button = AppUIButton(width: 0, text: getString("fragment_bluetooth_app_details_settings"), backgroundColor: Colors.colorAccent, textColor: Colors.colorPrimary)
        
        button.addTarget(self, action: #selector(self.clickBtnSettings), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: button callbacks
    @objc private func clickBtnSettings() {
        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(url as URL)
            btnCloseClick()
        }
    }
}
