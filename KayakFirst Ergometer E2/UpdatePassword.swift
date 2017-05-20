//
//  UpdatePassword.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UpdatePassword: ServerService<User> {
    
    private let currentPassword: String
    private let newPassword: String
    
    init(currentPassword: String, newPassword: String) {
        self.currentPassword = currentPassword
        self.newPassword = newPassword
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> User? {
        var user: User?
        
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            user = User(json: jsonValue)
        }
        
        return user
    }
    
    override func initUrlTag() -> String {
        return "users/password/update"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "currentPassword": currentPassword,
            "newPassword": newPassword
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    override func isEqual(anotherServerService: ServerService<User>) -> Bool {
        return true
    }
    
    override func getManagerType() -> BaseManagerType {
        return UserManagerType.update_pw
    }
    
}
