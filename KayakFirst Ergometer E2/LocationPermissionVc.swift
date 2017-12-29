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
            
            (contentLayout as! VcLocationPermissionLayout).imgLocationIcon.image = icon
            (contentLayout as! VcLocationPermissionLayout).imgLocationIcon.color = iconColor!
            (contentLayout as! VcLocationPermissionLayout).label.text = text
        }
    }
    
    override func getContentLayout(contentView: UIView) -> VcLocationPermissionLayout {
        return VcLocationPermissionLayout(contentView: contentView)
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        //TODO: move this to BaseVc
        self.contentLayout = getContentLayout(contentView: contentView)
        self.contentLayout?.setView()
        ///////////////////////////
        
        (contentLayout as! VcLocationPermissionLayout).btnSetting.addTarget(self, action: #selector(self.clickBtnSettings), for: .touchUpInside)
    }
    
    override func initTabBarItems() {
        showLogoOnRight()
        showCloseButton()
    }
    
    //MARK: button callbacks
    @objc private func clickBtnSettings() {
        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(url as URL)
            btnCloseClick()
        }
    }
}
