//
//  CalculateElementSOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

class CalculateElementSOutdoor: CalculateElementS<StartCommandOutdoor> {
    
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    
    override func run() -> Training {
        if latitude == 0 {
            latitude = startCommand.latitude
        }
        if longitude == 0 {
            longitude = startCommand.longitude
        }
        
        let currentLatitude = startCommand.latitude
        let currentLongitude = startCommand.longitude
        
        calculatedValue = measureDistance(loc1: getLocation(latitude: currentLatitude, longitude: currentLongitude), loc2: getLocation(latitude: latitude, longitude: longitude))
        
        latitude = currentLatitude
        longitude = currentLongitude
        
        return createTrainingObject()
    }
    
    private func measureDistance(loc1: CLLocation, loc2: CLLocation) -> Double {
        return loc1.distance(from: loc2)
    }
    
    private func getLocation(latitude: Double, longitude: Double) -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
}
