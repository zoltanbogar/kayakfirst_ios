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
        var serverWasReachable = true
        if let pointersValue = pointers {
            for s in pointersValue {
                let uploadTrainingAvgs = UploadTrainingAvgs(sessionId: Double(s)!)
                uploadTrainingAvgs.run()
                serverWasReachable = serverWasReachable && uploadTrainingAvgs.serverWasReachable
                
                isUploadReady = isUploadReady && uploadTrainingAvgs.isUploadReady
            }
        }
        return serverWasReachable
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingAvgUpload
    }
}
