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
        return isAuthorizationStatusOk(status: CLLocationManager.authorizationStatus())
    }
    
    class func isAuthorizationStatusOk(status: CLAuthorizationStatus) -> Bool {
        var statusOk = false
        
        if #available(iOS 11, *) {
            statusOk = status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse
        } else {
            statusOk = status == CLAuthorizationStatus.authorizedAlways
        }
        
        return statusOk
    }
    
}
