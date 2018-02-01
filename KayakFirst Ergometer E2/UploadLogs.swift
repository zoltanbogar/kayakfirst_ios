//
//  UploadLogs.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 01..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UploadLogs: ServerService<Bool> {
    
    //MARK: properties
    private let message: String
    
    //MARK: init
    init(message: String) {
        self.message = message
    }
    
    //MARK: functions
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        return true
    }
    
    override func initUrlTag() -> String {
        return "uploadLog"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        let systemInfos = SystemInfoDbLoader.sharedInstance.loadData(predicate: nil)
        let logObjest = LogObjectDbLoader.sharedInstance.loadData(predicate: nil)
        
        let feedbackDto = FeedbackDto(message: message, systemInfos: systemInfos, logs: logObjest)
        
        var parameters = Array<[String:Any]>()
        parameters.append(feedbackDto.getParameters())
        
        return parameters.asParameters()
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    override func getManagerType() -> BaseManagerType {
        return LogManagerType.send_feedback
    }
    
}
