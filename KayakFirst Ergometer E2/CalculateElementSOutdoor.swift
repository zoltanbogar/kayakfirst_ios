//
//  CalculateElementSOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreLocation

class CalculateElementSOutdoor: CalculateElementS<MeasureCommand, CommandProcessorOutdoor> {
    
    private var currentLocation: AppLocation?
    
    private var currentTime: Double = 0
    private var distanceSum: Double = 0
    private var speed: Double = 0
    
    override func run() -> Training {
        let location = startCommand.location
        
        if location != nil {
            if currentLocation == nil {
                currentLocation = location
            }
            
            if telemetry.checkCycleState(cycleState: CycleState.resumed) {
                calculate(location: location!)
                
                calculatedValue = distanceSum
                
                startCommand.distanceSum = distanceSum
                startCommand.speed = speed
            }
            
            currentLocation = location
        }
        
        return createTrainingObject()
    }
    
    private func calculate(location: AppLocation) {
        var speed: Double = 0
        
        let distance = getDistance(loc1: location, loc2: currentLocation!)
        
        log("LOC_TEST", "distance: \(distance)")
        
        if currentTime == 0 {
            currentTime = telemetry.getAbsoluteTimestamp()
        }
        
        if location.speed >= 0 {
            speed = location.speed
        } else {
            let timeDiff = telemetry.getAbsoluteTimestamp() - currentTime
            if timeDiff > 0 {
                speed = (distance / timeDiff) * 1000
            }
        }
        
        currentTime = telemetry.getAbsoluteTimestamp()
        
        speed = speed * converSationMpsKmph
        
        if speed <= maxSpeedKmph {
            self.speed = speed
            distanceSum += distance
        }
    }
    
    private func getDistance(loc1: AppLocation, loc2: AppLocation) -> Double {
        let location1 = CLLocation(
            latitude: loc1.latitude,
            longitude: loc1.longitude)
        let location2 = CLLocation(
            latitude: loc2.latitude,
            longitude: loc2.longitude)
        
        return location1.distance(from: location2)
    }
}
