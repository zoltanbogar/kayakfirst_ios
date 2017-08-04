//
//  UserResetPassword.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserResetPassword: ServerService<Bool> {
    
    private let email: String
    
    init(email: String) {
        self.email = email
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        return true
    }
    
    override func initUrlTag() -> String {
        return "users/pwreset"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "email": email,
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func initHeader() -> HTTPHeaders? {
        return nil
    }
    
    override func getManagerType() -> BaseManagerType {
        return UserManagerType.reset_pw
    }
}
