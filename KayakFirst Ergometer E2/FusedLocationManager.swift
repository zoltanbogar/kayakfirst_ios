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
    var currentLocation: CLLocation?
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        log("LOCATION", "update: \(locValue.latitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("LOCATION", "error: \(error.localizedDescription)")
    }
    
}
