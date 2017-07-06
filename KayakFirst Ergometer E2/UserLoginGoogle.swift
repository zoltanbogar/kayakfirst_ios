//
//  UserLoginGoogle.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserLoginGoogle: ServerService<Bool> {
    
    private let email: String
    private let googleId: String
    
    init(email: String, googleId: String) {
        self.email = email
        self.googleId = googleId
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        var loginDto: LoginDto?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonVlaue = JSON(json)
            
            let user = User(json: jsonVlaue["user"])
            loginDto = LoginDto(json: jsonVlaue)
            loginDto!.user = user
            
            UserManager.sharedInstance.addLoginDto(loginDto: loginDto)
            return true
        }
        
        return false
    }
    
    override func initUrlTag() -> String {
        return "login/google"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "email": email,
            "id": googleId
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return UserManagerType.login_google
    }
    
}
