//
//  UploadPlanTraining.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UploadPlanTraining: ServerService<Bool> {
    
    private var planTrainingParameters: Array<[String:Any]>
    
    init(planTrainingList: [PlanTraining]) {
        planTrainingParameters = Array<[String:Any]>()
        for planTraining in planTrainingList {
            planTrainingParameters.append(planTraining.getParameters())
        }
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> Bool? {
        return true
    }
    
    override func initUrlTag() -> String {
        return "planTraining/upload"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return planTrainingParameters.asParameters()
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    override func getManagerType() -> BaseManagerType {
        return PlanManagerType.upload
    }
}
