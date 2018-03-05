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

class DownloadPlanTrainingBySessionIds: ServerService<[PlanTraining]> {
    
    private let sessionIds: [Double]
    
    //TODO: maybe: Double(Int64(sessionId))
    init(sessionIds: [Double]) {
        self.sessionIds = sessionIds
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [PlanTraining]? {
        var planTrainings: [PlanTraining]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            log("SERVER_TEST", "\(jsonValue)")
            
            if let jsonArray = jsonValue.array {
                planTrainings = [PlanTraining]()
                
                for planTrainingDto in jsonArray {
                    let planTraining = PlanTraining(json: planTrainingDto)
                    
                    if planTraining != nil {
                        planTrainings?.append(planTraining!)
                    }
                }
            }
        }
        return planTrainings
    }
    
    override func initUrlTag() -> String {
        return "planTraining/downloadBySessionIds"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return sessionIds.asParameters()
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    override func getManagerType() -> BaseManagerType {
        return PlanManagerType.download_plan
    }
}
