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
    
    init(userDto: UserDto) {
        self.userDto = userDto
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
            "gender": userDto.gender ?? "",
            "birthDate": userDto.birthDate ?? nil,
            "country": userDto.country ?? "",
            "password": userDto.password ?? "",
            "username": userDto.userName ?? ""
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
}