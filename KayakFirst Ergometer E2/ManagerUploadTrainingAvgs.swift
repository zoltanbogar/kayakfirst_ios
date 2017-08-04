//
//  ManagerUploadTrainingAvgs.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerUploadTrainingAvgs: ManagerUpload {
    
    //MARK: properties
    private var isUploadReady = true
    
    override func callServer() {
        let serverWasReachable = runServer(pointers: getPointers())
        
        if serverWasReachable && isUploadReady {
            removeFromStack(uploadType: getUploadType())
        }
    }
    
    override func runServer(pointers: [String]?) -> Bool {
        if let pointersValue = pointers {
            for s in pointersValue {
                let uploadTrainingAvgs = UploadTrainingAvgs(sessionId: Double(s)!)
                uploadTrainingAvgs.run()
                let serverWasReachable = uploadTrainingAvgs.serverWasReachable
                
                if isUploadReady {
                    isUploadReady = uploadTrainingAvgs.isUploadReady
                }
                
                return serverWasReachable
            }
        }
        return true
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingAvgUpload
    }
    
}
