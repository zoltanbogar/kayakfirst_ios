//
//  DownloadEventDays.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadEventDays: ServerService<[TimeInterval]> {
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [TimeInterval]? {
        var eventDays: [TimeInterval]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            eventDays = [TimeInterval]()
            
            for eventDay in jsonValue.arrayObject! {
                
                eventDays?.append(DateFormatHelper.getZeroHour(timeStamp: TimeInterval(eventDay as! String)!))
            }
        }
        return eventDays
    }
    
    override func initUrlTag() -> String {
        return "event/days"
    }
    
    override func initMethod() -> HTTPMethod {
        return .get
    }
    
    override func initParameters() -> Parameters? {
        return nil
    }
    
    override func initEncoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return EventManagerType.download_event_days
    }
    
}
