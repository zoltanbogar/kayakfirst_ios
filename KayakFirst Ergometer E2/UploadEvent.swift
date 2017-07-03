//
//  UploadEvent.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UploadEvent: ServerService<Bool> {
    
    private var eventParameters: Array<[String:Any]>
    
    init(eventList: [Event]) {
        eventParameters = Array<[String:Any]>()
        for event in eventList {
            eventParameters.append(event.getParameters())
        }
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        return true
    }
    
    override func initUrlTag() -> String {
        return "event/upload"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return eventParameters.asParameters()
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    override func getManagerType() -> BaseManagerType {
        return EventManagerType.upload
    }
}
