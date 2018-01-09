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
    private let telemetry = Telemetry.sharedInstance
    private let locationManager = CLLocationManager()
    
    private let commandOutdoorLocation: CommandOutdoorLocation
    private let commandOutdoorStroke: CommandOutdoorStroke
    private let commandList: [MeasureCommand]
    
    private var _isNewLocationAvailable = false
    var isNewLocationAvailable: Bool {
        get {
            let isNew = _isNewLocationAvailable
            _isNewLocationAvailable = false
            return isNew
        }
    }
    
    //MARK: init
    static let sharedInstance = FusedLocationManager()
    private override init() {
        locationManager.allowsBackgroundLocationUpdates = true
        
        commandOutdoorLocation = CommandOutdoorLocation()
        commandOutdoorStroke = CommandOutdoorStroke()
        
        commandList = [commandOutdoorLocation, commandOutdoorStroke]
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
    
    func getCommandList(appSensorManager: AppSensorManager) -> [MeasureCommand] {
        commandOutdoorStroke.setValue(value: appSensorManager.strokesPerMin)
        
        return commandList
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        //let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        if locations.count > 0 {
            let accuracy = locations[0].horizontalAccuracy
            
            if accuracy <= accuracyLocation {
                _isNewLocationAvailable = true
                
                commandOutdoorLocation.setLocation(location: locations[0])
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("LOCATION", "error: \(error.localizedDescription)")
    }
    
}
