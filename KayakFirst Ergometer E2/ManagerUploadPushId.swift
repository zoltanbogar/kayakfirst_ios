//
//  ManagerUploadPushId.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerUploadPushId: ManagerUpload {
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachable = true
        if let pointersValue = pointers {
            if pointersValue.count > 0 {
                let pushId = pointersValue[pointersValue.count - 1]
                
                let uploadPushId = UploadPushId(pushId: pushId)
                uploadPushId.run()
                serverWasReachable = uploadPushId.serverWasReachable
            }
        }
        return serverWasReachable
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.pushIdUpload
    }
}
