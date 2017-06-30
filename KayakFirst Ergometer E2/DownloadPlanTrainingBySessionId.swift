//
//  DownloadPlanTrainingBySessionId.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadPlanTrainingBySessionId: ServerService<[PlanTraining]> {
    
    let sessionIdFrom: TimeInterval
    let sessionIdTo: TimeInterval
    
    init(sessionIdFrom: TimeInterval, sessionIdTo: TimeInterval) {
        self.sessionIdFrom = sessionIdFrom
        self.sessionIdTo = sessionIdTo
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [PlanTraining]? {
        var planTrainings: [PlanTraining]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            planTrainings = [PlanTraining]()
            planTrainings?.append(PlanTraining(json: jsonValue))
        }
        return planTrainings
    }
    
    override func initUrlTag() -> String {
        return "planTraining/downloadBySessionId"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "sessionIdFrom": sessionIdFrom,
            "sessionIdTo": sessionIdTo
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return PlanManagerType.download_plan
    }
}
