//
//  UserLoginFacebook.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserLoginFacebook: ServerService<LoginDto> {
    
    private let facebookToken: String
    
    init(facebookToken: String) {
        self.facebookToken = facebookToken
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> LoginDto? {
        var loginDto: LoginDto?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonVlaue = JSON(json)
            
            let user = User(json: jsonVlaue["user"])
            loginDto = LoginDto(json: jsonVlaue)
            loginDto!.user = user
            
            UserService.sharedInstance.addLoginDto(loginDto: loginDto)
        }
        
        return loginDto
    }
    
    override func initUrlTag() -> String {
        return "login/facebook"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "code": facebookToken
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return UserManagerType.login_facebook
    }
    
}
