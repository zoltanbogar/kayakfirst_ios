//
//  LoginDto.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 01..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginDto {
    
    var user: User?
    let userToken: String
    let refreshToken: String
    
    init(json: JSON) {
        self.userToken = json["user_token"].stringValue
        self.refreshToken = json["refresh_token"].stringValue
    }
}
