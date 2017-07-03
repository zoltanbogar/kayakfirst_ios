//
//  UserUpdate.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserUpdate: ServerService<User> {
    
    private let userDto: UserDto
    
    init(userDto: UserDto) {
        self.userDto = userDto
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> User? {
        var user: User?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            user = User(json: jsonValue)
            
            if user != nil {
                UserService.sharedInstance.addUser(user: user)
            }
        }
        return user
    }
    
    override func initUrlTag() -> String {
        return "users/update"
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
            "username": userDto.userName ?? ""
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return UserManagerType.update_user
    }
    
}
