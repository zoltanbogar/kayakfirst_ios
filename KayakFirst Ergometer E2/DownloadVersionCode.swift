//
//  DownloadVersionCode.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 23..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadVersionCode: ServerService<Int> {
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Int? {
        var versionCode: Int?
        
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            versionCode = jsonValue["ios"].intValue
        }
        return versionCode
    }
    
    override func initUrlTag() -> String {
        return "version"
    }
    
    override func initMethod() -> HTTPMethod {
        return .get
    }
    
    override func initEncoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return UserManagerType.downloadVersion
    }
    
}
