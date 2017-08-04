//
//  UploadPlan.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UploadPlan: ServerService<Bool> {
    
    private var planParameters: Array<[String:Any]>
    
    init(planList: [Plan]) {
        planParameters = Array<[String:Any]>()
        for plan in planList {
            planParameters.append(plan.getParameters())
        }
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        return true
    }
    
    override func initUrlTag() -> String {
        return "plan/upload"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return planParameters.asParameters()
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    override func getManagerType() -> BaseManagerType {
        return PlanManagerType.upload
    }
}
