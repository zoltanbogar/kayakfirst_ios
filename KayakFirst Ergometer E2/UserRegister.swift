//
//  UserRegister.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserRegister: ServerService<User> {
    
    private let userDto: UserDto
    private let facebookId: String?
    private let googleId: String?
    
    init(userDto: UserDto, facebookId: String?, googleId: String?) {
        self.userDto = userDto
        self.facebookId = facebookId
        self.googleId = googleId
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> User? {
        var user: User?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            user = User(json: jsonValue["user"])
            
            if user != nil {
                UserLogin(userName: userDto.userName!, userPassword: userDto.password!).run()
            }
        }
        return user
    }
    
    override func initUrlTag() -> String {
        return "register"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "lastName": userDto.lastName ?? "",
            "firstName": userDto.firstName ?? "",
            "email": userDto.email ?? "",
            "bodyWeight": userDto.bodyWeight ?? 0,
            "club": userDto.club ?? "",
            "gender": userDto.gender ?? "",
            "birthDate": userDto.birthDate ?? nil,
            "country": userDto.country ?? "",
            "artOfPaddling": userDto.artOfPaddling ?? "",
            "password": userDto.password ?? "",
            "username": userDto.userName ?? "",
            "facebookId": facebookId ?? "",
            "googleId": googleId ?? ""
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return UserManagerType.register
    }
}
