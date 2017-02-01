//
//  UserLogin.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 01..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserLogin: ServerService<AnyObject> {
    
    private let userName: String
    private let userPassword: String
    
    init(userName: String, userPassword: String) {
        self.userName = userName
        self.userPassword = userPassword
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> AnyObject? {
        var loginDto: LoginDto?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonVlaue = JSON(json)
            
            let user = User(json: jsonVlaue["user"])
            loginDto = LoginDto(json: jsonVlaue)
            loginDto!.user = user
        }
        
        return loginDto
    }
    
    override func initUrlTag() -> String {
        return "login"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "username": userName,
            "password": userPassword
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
}
