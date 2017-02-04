//
//  RefreshTokenDto.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

class RefreshTokenDto {
    
    var refreshToken: String
    var token: String
    
    init(json: JSON) {
        self.refreshToken = json["refresh_token"].stringValue
        self.token = json["token"].stringValue
    }
    
}
