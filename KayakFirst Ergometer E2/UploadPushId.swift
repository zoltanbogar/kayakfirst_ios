//
//  UploadPushId.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UploadPushId: ServerService<Bool> {
    
    //MARK: properties
    private let pushId: String;
    private let versionCode: String
    
    //MARK: init
    init(pushId: String) {
        self.pushId = pushId
        self.versionCode =  AppDelegate.buildString
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        return true
    }
    
    override func initUrlTag() -> String {
        return "users/uploadPushId"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "ios_token" : pushId,
            "version_code" : versionCode
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return UserManagerType.uploadPushId
    }
}
