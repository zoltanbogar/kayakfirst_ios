//
//  AppSensorManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 27..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import CoreMotion

//TODO: info.plist: https://developer.apple.com/reference/coremotion
class AppSensorManager {
    
    //MARK: properties
    private let sensorManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    
    var cycleIndex: Double = 0
    
    //MARK: init
    static let sharedInstance = AppSensorManager()
    private init() {
        if sensorManager.isAccelerometerAvailable {
            sensorManager.accelerometerUpdateInterval = 0.02
            operationQueue.name = "accelerometer"
        }
    }
    
    func reset() {
        //TODO
    }
    
    func startSensorMonitoring(start: Bool) {
        if start {
            sensorManager.startAccelerometerUpdates(to: operationQueue, withHandler: {
                [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    
                    self?.cycleIndex = pow(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z, 0.5)
                    
                    log("SENSOR", "acc: \(self?.cycleIndex)")
                }
            })
        } else {
            sensorManager.stopAccelerometerUpdates()
        }
    }
    
}
