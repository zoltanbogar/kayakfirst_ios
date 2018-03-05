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
                
                isUploadReady = isUploadReady && uploadTrainings.isUploadReady
                
                if serverWasReachable {
                    if uploadTrainings.pointer != 0 {
                        timestamp = uploadTrainings.pointer
                        setLocaelPointer(timestamp: timestamp)
                    }
                }
                
                if !serverWasReachable || !isUploadReady {
                    break
                }
                
                if isUploadReady && serverWasReachable {
                    ManagerUpload.addToStack(uploadType: UploadType.trainingAvgUpload, pointer: s)
                    ManagerUpload.addToStack(uploadType: UploadType.trainingSumUpload, pointer: s)
                }
            }
        }
        return serverWasReachable
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingUpload
    }
    
    func getNotUploadedSessionIds() -> [Double]? {
        var sessionIds = [Double]()
        
        let pointers = getPointers()
        
        if let pointers = pointers {
            for s in pointers {
                sessionIds.append(Double(s)!)
            }
        }
        return sessionIds
    }
    
    private func setLocaelPointer(timestamp: Double) {
        preferences.set(timestamp, forKey: getLocalePointerKey())
    }
    
    private func getLocalePointer() -> Double {
        return preferences.double(forKey: getLocalePointerKey())
    }
    
    private func getLocalePointerKey() -> String {
        let user = UserManager.sharedInstance.getUser()
        
        if let userValue = user {
            return keyTrainingUploadPointer + "_" + String(userValue.id)
        }
        return keyTrainingUploadPointer
    }
}
