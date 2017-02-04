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
}

class ServerService<E> {
    
    //MARK: constants
    let baseUrl = "http://kayak.einnovart.hu/api/"
    
    //MARK: properties
    var error: Responses?
    
    func run() -> E? {
        var result: E?
        if Reachability.isConnectedToNetwork() {
            let response = initAlamofire()
            
            let statusCode = response.responseString().response?.statusCode == nil ? 0 : response.response?.statusCode
            
            if statusCode! >= 200 && statusCode! < 300 {
                result = handleServiceCommunication(alamofireRequest: response)
            } else {
                //TODO
            }
            
        } else {
            error = Responses.error_no_internet
            return nil
        }
        
        return result
    }
    
    internal func handleServiceCommunication(alamofireRequest: DataRequest) -> E? {
        fatalError("Must be implemented")
    }
    
    internal func initUrlTag() -> String {
        fatalError("Must be implemented")
    }
    
    internal func initMethod() -> HTTPMethod {
        fatalError("Must be implemented")
    }
    
    internal func initParameters() -> Parameters? {
        return nil
    }
    
    internal func initEncoding() -> ParameterEncoding {
        fatalError("Must be implemented")
    }
    
    internal func initHeader() -> HTTPHeaders? {
        let token = UserService.sharedInstance.token
        
        if let userToken = token {
            return [
                "Authorization":"Bearer "+userToken
            ]
        }
        return nil
    }
    
    private func initAlamofire() -> DataRequest {
        let url = baseUrl + initUrlTag()
        return Alamofire.request(
            url,
            method: initMethod(),
            parameters: initParameters(),
            encoding: initEncoding(),
            headers: initHeader())
        .debugLog()
    }
    
}
