//
//  PermissionCheck.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 24..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

class PermissionCheck {
    
    class func hasLocationPermission() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways 
    }
    
}
