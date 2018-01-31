//
//  GpsAvailableCheck.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 31..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

class GpsAvailableCheck {
    
    //MARK: constants
    private let gpsInterval: Double = 1000 //1 sec
    private let accuracyLocation: Double = 10 //10 meters
    
    //MARK: properties
    private let locationService: FusedLocationManager
    
    private var timer: Timer?
    
    private var lastLocationTimestamp: Double = 0
    private var location: CLLocation?
    
    //MARK: init
    init(locationService: FusedLocationManager) {
        self.locationService = locationService
    }
    
    //MARK: functions
    func startChecking(isStart: Bool) {
        timer?.invalidate()
        
        locationService.gpsAvailable(isAvailabe: true)
        
        if isStart {
            timer = Timer.scheduledTimer(timeInterval: gpsInterval / 1000, target: self, selector: #selector(checkAvailability), userInfo: nil, repeats: true)
        }
    }
    
    func onLocationAvailable(location: CLLocation) {
        self.location = location
        self.lastLocationTimestamp = currentTimeMillis()
    }
    
    func isGpsAvailable() -> Bool {
        return isTimeDiffOk() && isAccuracyOk()
    }
    
    private func isTimeDiffOk() -> Bool {
        let timeDiff = currentTimeMillis() - lastLocationTimestamp
        return timeDiff <= gpsInterval * 2
    }
    
    private func isAccuracyOk() -> Bool {
        var accuracy = accuracyLocation + 1
        
        if let location = location {
            accuracy = location.horizontalAccuracy
        }
        
        return accuracy <= accuracyLocation
    }
    
    @objc private func checkAvailability() {
        locationService.gpsAvailable(isAvailabe: isGpsAvailable())
    }
}
