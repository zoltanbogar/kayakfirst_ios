//
//  ManagerUploadTrainingSums.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 03. 05..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerUploadTrainingSums: ManagerUpload {
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachable = true
        if let pointersValue = pointers {
            let localePointers = pointersValue.map { stringPointer in
                Double(stringPointer)!
            }
            let uploadSumTrainings = UploadTrainingSums(sessionIds: localePointers)
            uploadSumTrainings.run()
            serverWasReachable = uploadSumTrainings.error == nil
        }
        return serverWasReachable
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingSumUpload
    }
}
