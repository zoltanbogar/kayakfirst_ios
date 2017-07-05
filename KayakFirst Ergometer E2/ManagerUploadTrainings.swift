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
    override func callServer() -> String? {
        var error = runServer(pointers: getPointers())
        
        if error == nil {
            removeFromStack(uploadType: getUploadType())
            
            if !isUploadReady {
                if pointerTimestamp != 0 {
                    addToStack(uploadType: getUploadType(), pointer: "\(pointerTimestamp)")
                }
            }
        }
        return error
    }
    
    override func runServer(pointers: [String]?) -> String? {
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
            
            return uploadTrainings.error?.rawValue
        }
        return nil
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingUpload
    }
}
