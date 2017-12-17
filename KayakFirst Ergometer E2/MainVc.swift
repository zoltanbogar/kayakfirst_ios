//
//  MainVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import CoreLocation

func startMainVc(navigationViewController: UINavigationController, plan: Plan?, event: Event?) {
    
    let isValidPlan = plan == nil || Validate.isValidPlan(viewController: navigationViewController, plan: plan)
    
    if isValidPlan {
        let mainVc = MainVc()
        mainVc.plan = plan
        mainVc.event = event
        navigationViewController.pushViewController(mainVc, animated: true)
    }
}

class MainVc: MainTabVc, CLLocationManagerDelegate {
    
    //MARK: properteis
    private let locationManager = CLLocationManager()
    private var permissionViewController: UIViewController? = nil
    
    var trainingEnvironmentType: TrainingEnvironmentType?
    var plan: Plan?
    var event: Event?
    
    //MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WindowHelper.setBrightness(isFull: true)
    }
    
    //MARK: views
    override func initView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
                
        stackView.addArrangedSubview(btnErgo)
        stackView.addHorizontalSeparator(color: Colors.colorDashBoardDivider, thickness: 1)
        stackView.addArrangedSubview(btnOutdoor)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.center.equalTo(contentView)
        }
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
    }
    
    private lazy var btnErgo: UIButton! = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "halfBulb"), for: .normal)
        
        button.addTarget(self, action: #selector(clickBtnErgo), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var btnOutdoor: UIButton! = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "halfSun"), for: .normal)
        
        button.addTarget(self, action: #selector(clickBtnOutdoor), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func clickBtnOutdoor() {
        trainingEnvironmentType = TrainingEnvironmentType.outdoor
        
        checkLocationSettings()
    }
    
    @objc private func clickBtnErgo() {
        trainingEnvironmentType = TrainingEnvironmentType.ergometer
        
        checkLocationSettings()
    }
    
    private func checkLocationSettings() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            initPermissionViewController()
        } else {
            LocationSettingsDialog().show(viewController: self)
        }
    }
    
    private func initPermissionViewController() {
        if !PermissionCheck.hasLocationPermission() {
            permissionViewController = startLocationPermissionVc(viewController: self.parent!, trainingEnvType: trainingEnvironmentType!)
        } else {
            startTrainingViewController(viewController: self, plan: plan, event: event, trainingEnvType: trainingEnvironmentType!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (PermissionCheck.isAuthorizationStatusOk(status: status)) {
            if let permissionVc = permissionViewController {
                permissionVc.dismiss(animated: true, completion: nil)
            }
        }
    }
}
