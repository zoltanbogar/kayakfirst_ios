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
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachable = true
        if let pointersValue = pointers {
            var timestamp: Double = getLocalePointer()
            
            for s in pointersValue {
                let sessionId = Double(s)
                
                var uploadTrainings = UploadTrainings(sessionId: sessionId!, timestamp: timestamp)
                uploadTrainings.run()
                serverWasReachable = serverWasReachable && uploadTrainings.serverWasReachable
                
                if serverWasReachable {
                    timestamp = uploadTrainings.pointer
                    setLocaelPointer(timestamp: timestamp)
                }
                
                while !uploadTrainings.isUploadReady && uploadTrainings.serverWasReachable {
                    uploadTrainings = UploadTrainings(sessionId: sessionId!, timestamp: timestamp)
                    uploadTrainings.run()
                    serverWasReachable = serverWasReachable && uploadTrainings.serverWasReachable
                    
                    if serverWasReachable {
                        timestamp = uploadTrainings.pointer
                        setLocaelPointer(timestamp: timestamp)
                    }
                }
            }
        }
        return serverWasReachable
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingUpload
    }
    
    private func setLocaelPointer(timestamp: Double) {
        if timestamp != 0 {
            preferences.set(timestamp, forKey: keyTrainingUploadPointer)
        }
    }
    
    private func getLocalePointer() -> Double {
        return preferences.double(forKey: keyTrainingUploadPointer)
    }
}
