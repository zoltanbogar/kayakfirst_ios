//
//  ManagerUploadTrainings.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerUploadTrainings: ManagerUpload {
    
    //MARK: properties
    private var pointerTimestamp: Double = 0
    private var isUploadReady = false
    
    //MARK: functions
    override func callServer() {
        var serverWasReachable = runServer(pointers: getPointers())
        
        if serverWasReachable {
            removeFromStack(uploadType: getUploadType())
            
            if !isUploadReady {
                if pointerTimestamp != 0 {
                    ManagerUpload.addToStack(uploadType: getUploadType(), pointer: "\(pointerTimestamp)")
                }
            }
        }
    }
    
    override func runServer(pointers: [String]?) -> Bool {
        if let pointersValue = pointers {
            var timestampPointer: String? = nil
            
            for s in pointersValue {
                timestampPointer = s
                break
            }
            
            let uploadTrainings = UploadTrainings(timestamp: timestampPointer)
            uploadTrainings.run()
            
            let error = uploadTrainings.error
            
            if error == nil {
                pointerTimestamp = uploadTrainings.pointer
                isUploadReady = uploadTrainings.isUploadReady
            }
            
            return uploadTrainings.serverWasReachable
        }
        return true
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingUpload
    }
}
