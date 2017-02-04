//
//  RefreshToken.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 04..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RefreshToken: ServerService<RefreshTokenDto> {
    
    private var refreshToken: String?
    
    override init() {
        super.init()
        self.refreshToken = UserService.sharedInstance.refreshToken
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> RefreshTokenDto? {
        var refreshTokenDto: RefreshTokenDto?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            refreshTokenDto = RefreshTokenDto(json: jsonValue)
        }
        
        return refreshTokenDto
    }
    
    override func initUrlTag() -> String {
        return "token/refresh"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "refresh_token": refreshToken!
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
}
