//
//  ServerService.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 01..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire_Synchronous
import Alamofire
import SwiftyJSON

//MARK: responses
enum Responses: String {
    case error_no_internet = "error_no_internet"
    case error_invalid_credentials = "INVALID_CREDENTIALS"
    case error_server_error = "server_error"
    case error_expired_token = "Expired JWT Token"
    case error_registration_required = "Registration required"
    case error_used_username = "The username is already used."
    case error_used_email = "The email is already used."
    case error_social = "error_social"
}

class ServerService<E> {
    
    //MARK: constants
    //TODO
    let baseUrl = "http://192.168.0.119:8000/api/"
    
    //MARK: properties
    var error: Responses?
    var serverWasReachable = false
    
    private let logManager = LogManager.sharedInstance
    
    func run() -> E? {
        serverWasReachable = true
        
        var data = runBase()
        
        if data == nil && error == Responses.error_expired_token {
            error = nil
            
            refreshToken()
            
            return runBase()
        }
        return data
    }
    
    private func runBase() -> E? {
        var result: E?
        if preCheck() {
            if Reachability.isConnectedToNetwork() {
                let response = initAlamofire()
                
                let statusCode = response.responseString().response?.statusCode == nil ? 0 : response.response?.statusCode
                
                logManager.logServer(message: response)
                
                if statusCode! >= 200 && statusCode! < 300 {
                    result = handleServiceCommunication(alamofireRequest: response)
                } else if statusCode == 0 {
                    serverWasReachable = false
                    error = initError(alamofireRequest: response)
                } else {
                    error = initError(alamofireRequest: response)
                }
                
            } else {
                serverWasReachable = false
                error = Responses.error_no_internet
                return nil
            }
        } else {
            result = getResultFromCache()
        }
        
        return result
    }
    
    //MARK: abstract methods
    internal func handleServiceCommunication(alamofireRequest: DataRequest) -> E? {
        fatalError("Must be implemented")
    }
    
    internal func initUrlTag() -> String {
        fatalError("Must be implemented")
    }
    
    internal func initMethod() -> HTTPMethod {
        fatalError("Must be implemented")
    }
    
    internal func initEncoding() -> ParameterEncoding {
        fatalError("Must be implemented")
    }
    
    internal func getManagerType() -> BaseManagerType {
        fatalError("Must be implemented")
    }
    
    internal func initParameters() -> Parameters? {
        return nil
    }
    
    private func refreshToken() {
        let refreshTokenDto = RefreshToken().run()
        if refreshTokenDto != nil {
            UserManager.sharedInstance.setTokens(token: refreshTokenDto!.token, refreshToken: refreshTokenDto!.refreshToken)
        }
    }
    
    //override if needed
    internal func preCheck() -> Bool {
        return true
    }
    
    //override if needed
    internal func getResultFromCache() -> E? {
        return nil
    }
    
    internal func initHeader() -> HTTPHeaders? {
        let token = UserManager.sharedInstance.token
        
        if let userToken = token {
            return [
                "Authorization":"Bearer "+userToken
            ]
        }
        return nil
    }
    
    private func initAlamofire() -> DataRequest {
        let url = baseUrl + initUrlTag()
        let alamofireManager = (UIApplication.shared.delegate as! AppDelegate).alamofireManager
        let dataRequest = alamofireManager.request(
            url,
            method: initMethod(),
            parameters: initParameters(),
            encoding: initEncoding(),
            headers: initHeader())
        
        log(alamofireLogTag, "\(initParameters())")
        
        return dataRequest.debugLog()
    }
    
    private func initError(alamofireRequest: DataRequest) -> Responses? {
        let response = alamofireRequest.responseJSON()
        
        logManager.logServer(message: response)
        
        var errorString = response.result.debugDescription
        
        if errorString.contains(Responses.error_registration_required.rawValue) {
            return Responses.error_registration_required
        } else {
            if let json = response.result.value {
                let jsonValue = JSON(json)
                
                if jsonValue["error"].stringValue != "" {
                    errorString = jsonValue["error"].stringValue
                } else if jsonValue["username"].stringValue != "" {
                    errorString = jsonValue["username"].stringValue
                } else if jsonValue["email"].stringValue != "" {
                    errorString = jsonValue["email"].stringValue
                }
                
                switch errorString {
                case Responses.error_invalid_credentials.rawValue:
                    return Responses.error_invalid_credentials
                case Responses.error_expired_token.rawValue:
                    return Responses.error_expired_token
                case Responses.error_used_username.rawValue:
                    return Responses.error_used_username
                case Responses.error_used_email.rawValue:
                    return Responses.error_used_email
                default:
                    return Responses.error_server_error
                }
            }
        }
        return Responses.error_server_error
    }
}
