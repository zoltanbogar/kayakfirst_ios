//
//  LocationPermittionVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

func startLocationPermissionVc(viewController: UIViewController) {
    let navController = UINavigationController()
    navController.pushViewController(LocationPermissionVc(), animated: false)
    viewController.present(navController, animated: true, completion: nil)
}

class LocationPermissionVc: BaseVC {
    
    //MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationPermission()
    }
    
    //MARK: check permission
    private func checkLocationPermission() {
        if PermissionCheck.hasLocationPermission() {
            btnCloseClick()
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
        self.navigationItem.setLeftBarButtonItems([btnClose], animated: true)
        showLogoOnRight()
    }
    
    //MARK: views
    private lazy var imgLocationIcon: UIButton! = {
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
    
    private lazy var btnSetting: UIButton! = {
        let button = AppUIButton(width: 0, text: getString("fragment_bluetooth_app_details_settings"), backgroundColor: Colors.colorAccent, textColor: Colors.colorPrimary)
        
        button.addTarget(self, action: #selector(self.clickBtnSettings), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: tabbarItems
    private lazy var btnClose: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_clear_white_24dp")
        button.target = self
        button.action = #selector(btnCloseClick)
        
        return button
    }()
    
    //MARK: button callbacks
    @objc private func clickBtnSettings() {
        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(url as URL)
            btnCloseClick()
        }
    }
    
    @objc private func btnCloseClick() {
        dismiss(animated: true, completion: nil)
    }
}
