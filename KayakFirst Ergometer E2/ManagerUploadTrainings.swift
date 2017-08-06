//
//  ManagerUploadTrainings.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerUploadTrainings: ManagerUpload {
    
    //MARK: constants
    private let keyTrainingUploadPointer = "training_upload_key"
    
    //MARK: properties
    private var pointerTimestamp: Double = 0
    
    private var preferences = UserDefaults.standard
    
    //MARK: functions
    override func callServer() {
        var serverWasReachable = runServer(pointers: getPointers())
        
        if serverWasReachable {
            removeFromStack(uploadType: getUploadType())
            
            if pointerTimestamp != 0 {
                ManagerUpload.addToStack(uploadType: getUploadType(), pointer: "\(pointerTimestamp)")
                setLocaelPointer(timestamp: pointerTimestamp)
            }
        }
    }
    
    override func runServer(pointers: [String]?) -> Bool {
        if let pointersValue = pointers {
            var timestampPointer: String? = nil
            
            if getLocalePointer() == 0 {
                for s in pointersValue {
                    timestampPointer = s
                    break
                }
            } else {
                timestampPointer = "\(getLocalePointer())"
            }
            
            let uploadTrainings = UploadTrainings(timestamp: timestampPointer)
            uploadTrainings.run()
            
            let serverWasReachable = uploadTrainings.serverWasReachable
            
            if serverWasReachable {
                pointerTimestamp = uploadTrainings.pointer
            }
            
            return serverWasReachable
        }
        return true
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingUpload
    }
    
    private func setLocaelPointer(timestamp: Double) {
        preferences.set(timestamp, forKey: keyTrainingUploadPointer)
    }
    
    private func getLocalePointer() -> Double {
        return preferences.double(forKey: keyTrainingUploadPointer)
    }
}
