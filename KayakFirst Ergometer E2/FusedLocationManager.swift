//
//  FusedLocationManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

protocol GpsAvailableListener {
    func gpsAvailabilityChanged(isAvailable: Bool)
}

class FusedLocationManager: NSObject, CLLocationManagerDelegate {
    
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
    private var _gpsAvailableCheck: GpsAvailableCheck!
    private var gpsAvailableCheck: GpsAvailableCheck {
        return _gpsAvailableCheck
    }
    var gpsAvailableListener: GpsAvailableListener?
    
    //MARK: init
    static let sharedInstance = FusedLocationManager()
    private override init() {
        locationManager.allowsBackgroundLocationUpdates = true
        
        commandOutdoorLocation = CommandOutdoorLocation()
        commandOutdoorStroke = CommandOutdoorStroke()
        
        commandList = [commandOutdoorLocation, commandOutdoorStroke]
        
        super.init()
        
        _gpsAvailableCheck = GpsAvailableCheck(locationService: self)
    }
    
    //MARK: start/stop monitoring
    func startLocationMonitoring(start: Bool) {
        if start {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.activityType = .fitness
                locationManager.startUpdatingLocation()
                gpsAvailableCheck.startChecking(isStart: true)
            }
        } else {
            locationManager.stopUpdatingLocation()
            gpsAvailableCheck.startChecking(isStart: false)
        }
    }
    
    func getCommandList(appSensorManager: AppSensorManager) -> [MeasureCommand] {
        commandOutdoorStroke.setValue(value: appSensorManager.strokesPerMin)
        
        return commandList
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            log("LOC_TEST", "newLocation: \(locations[0].horizontalAccuracy)")
            
            gpsAvailableCheck.onLocationAvailable(location: locations[0])
            
            if gpsAvailableCheck.isGpsAvailable() {
                _isNewLocationAvailable = true
                
                commandOutdoorLocation.setLocation(location: locations[0])
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("LOCATION", "error: \(error.localizedDescription)")
    }
    
    func gpsAvailable(isAvailabe: Bool) {
        DispatchQueue.main.async {
            self.gpsAvailableListener?.gpsAvailabilityChanged(isAvailable: isAvailabe)
        }
    }
    
}
