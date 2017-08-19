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
    private var isUploadReady = false
    
    private var preferences = UserDefaults.standard
    
    //MARK: functions
    override func callServer() {
        let serverWasReachable = runServer(pointers: getPointers())
        
        if serverWasReachable && isUploadReady {
            removeFromStack(uploadType: getUploadType())
        }
    }
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachable = true
        isUploadReady = true
        
        if let pointersValue = pointers {
            var timestamp: Double = getLocalePointer()
            
            for s in pointersValue {
                let sessionId = Double(s)
                
                let uploadTrainings = UploadTrainings(sessionId: sessionId!, timestamp: timestamp)
                uploadTrainings.run()
                serverWasReachable = serverWasReachable && uploadTrainings.serverWasReachable
                
                if serverWasReachable {
                    if uploadTrainings.pointer != 0 {
                        timestamp = uploadTrainings.pointer
                        setLocaelPointer(timestamp: timestamp)
                    }
                }
                
                isUploadReady = isUploadReady && uploadTrainings.isUploadReady
            }
        }
        return serverWasReachable
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
