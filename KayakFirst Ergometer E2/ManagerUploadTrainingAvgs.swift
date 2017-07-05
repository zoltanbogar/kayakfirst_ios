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
    
    override func callServer() -> String? {
        let error = runServer(pointers: getPointers())
        
        if error == nil && isUploadReady {
            removeFromStack(uploadType: getUploadType())
        }
        
        return error
    }
    
    override func runServer(pointers: [String]?) -> String? {
        if let pointersValue = pointers {
            for s in pointersValue {
                let uploadTrainingAvgs = UploadTrainingAvgs(sessionId: Double(s)!)
                uploadTrainingAvgs.run()
                let error = uploadTrainingAvgs.error
                
                if isUploadReady {
                    isUploadReady = uploadTrainingAvgs.isUploadReady
                }
                
                return error?.rawValue
            }
        }
        return nil
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingAvgUpload
    }
    
}
