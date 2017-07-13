//
//  DownloadMessage.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadMessage: ServerService<String> {
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> String? {
        
        //TODO
        return nil
    }
    
    override func initUrlTag() -> String {
        return "users/getMessage"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "languageCode" : NSLocale.current.languageCode ?? ""
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return UserManagerType.downloadMessage
    }
}
