//
//  MainVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import CoreLocation

class MainVc: MainTabVc {
    
    //MARK: properteis
    private let locationManager = CLLocationManager()
    
    //MARK: views
    override func initView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
                
        stackView.addArrangedSubview(btnErgo)
        stackView.addHorizontalSeparator(color: Colors.colorInactive, thickness: 1)
        stackView.addArrangedSubview(btnOutdoor)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.center.equalTo(contentView)
        }
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
        checkLocationSettings()
    }
    
    @objc private func clickBtnErgo() {
        startErgometerViewController(viewController: self)
    }
    
    private func checkLocationSettings() {
        if CLLocationManager.locationServicesEnabled() {
            startOutdoorViewController(viewController: self)
        } else {
            //TODO: sofisticate the method!
            locationManager.requestAlwaysAuthorization()
            
            LocationSettingsDialog().show(viewController: self)
            
            //UIApplication.shared.openURL(NSURL(string: "App-Prefs:root=LOCATION_SERVICES")! as URL)
        }
    }
}
