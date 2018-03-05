//
//  ManagerUploadTrainingAvgs.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerUploadTrainingAvgs: ManagerUpload {
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachable = true
        if let pointersValue = pointers {
            let localePointers = pointersValue.map { stringPointer in
                Double(stringPointer)!
            }
            let uploadTrainingAvgs = UploadTrainingAvgs(sessionIds: localePointers)
            uploadTrainingAvgs.run()
            serverWasReachable = uploadTrainingAvgs.error == nil
        }
        return serverWasReachable
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingAvgUpload
    }
}
