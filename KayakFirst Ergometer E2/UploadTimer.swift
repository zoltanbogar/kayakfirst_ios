//
//  UploadTimer.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class UploadTimer {
    
    //MARK: constants
    private static let timeUploadTrainingsSec: Double = 10
    private static var timer: Timer?
    
    class func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: timeUploadTrainingsSec, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        }
    }
    
    class func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private class func timerUpdate() {
        TrainingDataService.sharedInstance.uploadTrainingData()
    }
    
}
