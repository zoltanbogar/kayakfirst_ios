//
//  UploadTimer.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

//TODO: copy from Android
class UploadTimer {
    
    //MARK: constants
    private static let timeUploadTrainingsSec: Double = 20
    private static var timer: Timer?
    
    class func startTimer() {
        if timer == nil {
            DispatchQueue.main.async {
                //TODO: by training start this called twice in a row
                log("SERVER_TEST", "startTimer")
                timer = Timer.scheduledTimer(timeInterval: timeUploadTrainingsSec, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
            }
        }
    }
    
    class func stopTimer() {
        log("SERVER_TEST", "stopTimer")
        timer?.invalidate()
        timer = nil
    }
    
    @objc private class func timerUpdate() {
        TrainingManager.sharedInstance.runUpload()
    }
}
