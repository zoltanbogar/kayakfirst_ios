//
//  DownloadPlanByName.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadPlanByName: ServerService<[Plan]> {
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [Plan]? {
        var plans: [Plan]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            plans = [Plan]()
            plans?.append(Plan(json: jsonValue))
        }
        return plans
    }
    
    override func initUrlTag() -> String {
        return "plan/downloadByName"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "name": name
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return PlanManagerType.download_plan
    }
    
}
