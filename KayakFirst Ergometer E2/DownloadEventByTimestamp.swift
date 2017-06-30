//
//  DownloadEventByTimestamp.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadEventByTimestamp: ServerService<[Event]> {
    
    let timestampFrom: TimeInterval
    let timestampTo: TimeInterval
    
    init(timestampFrom: TimeInterval, timestampTo: TimeInterval) {
        self.timestampFrom = timestampFrom
        self.timestampTo = timestampTo
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [Event]? {
        var events: [Event]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            events = [Event]()
            events?.append(Event(json: jsonValue))
        }
        return events
    }
    
    override func initUrlTag() -> String {
        return "event/downloadByTimestamp"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "timestampFrom": timestampFrom,
            "timestampTo": timestampTo
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return EventManagerType.download_event
    }
}
