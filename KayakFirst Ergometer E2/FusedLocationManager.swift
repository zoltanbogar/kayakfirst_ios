//
//  FusedLocationManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

class FusedLocationManager: NSObject, CLLocationManagerDelegate {
    
    //MARK: constants
    private let accuracyLocation: Double = 10 //10 meters
    
    //MARK: properteis
    private let pauseDiff = PauseDiff.sharedInstance
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentTime: Double = 0
    private var _isNewLocationAvailable = true
    var isNewLocationAvailable: Bool {
        get {
            let isNew = _isNewLocationAvailable
            _isNewLocationAvailable = false
            return isNew
        }
    }
    
    var distanceSum: Double = 0
    var speed: Double = 0
    
    //MARK: init
    static let sharedInstance = FusedLocationManager()
    private override init() {
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    //MARK: start/stop monitoring
    func startLocationMonitoring(start: Bool) {
        if start {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.activityType = .fitness
                locationManager.startUpdatingLocation()
            }
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func reset() {
        currentLocation = nil
        currentTime = 0
        speed = 0
        distanceSum = 0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        //let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        if locations.count > 0 {
            let accuracy = locations[0].horizontalAccuracy
            
            if accuracy <= accuracyLocation {
                _isNewLocationAvailable = true
                if currentLocation == nil {
                    currentLocation = locations[0]
                }
                
                if Telemetry.sharedInstance.cycleState == CycleState.resumed {
                    calculate(location: locations[0])
                }
                currentLocation = locations[0]
                
                log("SPEED_TEST", "speed: \(locations[0].speed * 3.6), accuracy: \(locations[0].horizontalAccuracy)")
            }
        }
    }
    
    private func calculate(location: CLLocation) {
        var speed: Double = 0
        
        let distance = getDistance(loc1: location, loc2: currentLocation!)
        
        if currentTime == 0 {
            currentTime = pauseDiff.getAbsoluteTimeStamp()
        }
        
        if location.speed >= 0 {
            speed = location.speed
        } else {
            let timeDiff = pauseDiff.getAbsoluteTimeStamp() - currentTime
            if timeDiff > 0 {
                speed = (distance / timeDiff) * 1000
            }
        }
        
        currentTime = pauseDiff.getAbsoluteTimeStamp()
        
        speed = speed * converSationMpsKmph
        
        if speed <= maxSpeedKmph {
            self.speed = speed
            distanceSum += distance
        }
    }
    
    private func getDistance(loc1: CLLocation, loc2: CLLocation) -> Double {
        return loc1.distance(from: loc2)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("LOCATION", "error: \(error.localizedDescription)")
    }
    
}
