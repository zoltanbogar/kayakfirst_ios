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
        if let pointersValue = pointers {
            let pushId = pointersValue[pointersValue.count - 1]
            
            let uploadPushId = UploadPushId(pushId: pushId)
            uploadPushId.run()
            return uploadPushId.serverWasReachable
        }
        return false
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.pushIdUpload
    }
}
