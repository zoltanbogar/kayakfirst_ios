//
//  UserLogout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserLogout: ServerService<Bool> {
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        UserService.sharedInstance.addLoginDto(loginDto: nil)
        
        return true
    }
    
    override func initUrlTag() -> String {
        return "logout"
    }
    
    override func initMethod() -> HTTPMethod {
        return .get
    }
    
    override func initParameters() -> Parameters? {
        return nil
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
}
