//
//  AppLocation.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 07..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

struct AppLocation {
    
    static func newAppLocation(location: CLLocation?) -> AppLocation? {
        guard let location = location else {
            return nil
        }
        
        return AppLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            speed: location.speed)
    }
    
    let latitude: Double
    let longitude: Double
    let speed: Double
    
}
