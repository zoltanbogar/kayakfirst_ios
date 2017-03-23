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
    
    //MARK: properteis
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentTime: Double = 0
    var distanceSum: Double = 0
    var speed: Double = 0
    
    //MARK: init
    static let sharedInstance = FusedLocationManager()
    private override init() {
        //private empty constructor
    }
    
    //MARK: start/stop monitoring
    func startLocationMonitoring(start: Bool) {
        if start {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        log("LOCATION", "update: \(locValue.latitude)")
        
        if Telemetry.sharedInstance.cycleState == CycleState.resumed {
            if currentLocation == nil {
                currentLocation = location
            }
            
            calculateDistance(location: location)
            calculateSpeed(location: location)
            currentLocation = location
        }
    }
    
    private func calculateDistance(location: CLLocation) {
        distanceSum += getDistance(loc1: location, loc2: currentLocation!)
    }
    
    private func calculateSpeed(location: CLLocation) {
        var speed: Double = 0
        
        if currentTime == 0 {
            currentTime = currentTimeMillis()
        }
        
        if location.speed >= 0 {
            speed = location.speed
        } else {
            let timeDiff = currentTimeMillis() - currentTime
            if timeDiff > 0 {
                let distance = getDistance(loc1: location, loc2: currentLocation!)
                speed = (distance / timeDiff) * 1000
            }
        }
        
        currentTime = currentTimeMillis()
        self.speed = speed * converSationMpsKmph
    }
    
    private func getDistance(loc1: CLLocation, loc2: CLLocation) -> Double {
        return loc1.distance(from: loc2)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("LOCATION", "error: \(error.localizedDescription)")
    }
    
}
