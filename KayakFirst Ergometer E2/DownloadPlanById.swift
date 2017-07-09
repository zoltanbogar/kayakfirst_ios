//
//  DownloadPlanById.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadPlanById: ServerService<Plan> {
    
    let planId: String
    
    init(planId: String) {
        self.planId = planId
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Plan? {
        var plan: Plan?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            plan = Plan(json: jsonValue)
        }
        return plan
    }
    
    override func initUrlTag() -> String {
        return "plan/downloadById"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "planId": planId
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return PlanManagerType.download_plan
    }
    
}
