//
//  DownloadTrainingAvgsBySessionIds.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 20..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadTrainingAvgsBySessionIds: ServerService<[TrainingAvg]> {
    
    private let sessionIds: [Double]
    
    //TODO: maybe: Double(Int64(sessionId))
    init(sessionIds: [Double]) {
        self.sessionIds = sessionIds
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [TrainingAvg]? {
        var trainingAvgs: [TrainingAvg]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            if let jsonArray = jsonValue.array {
                trainingAvgs = [TrainingAvg]()
                
                for trainingAvgDto in jsonArray {
                    let trainingAvg = TrainingAvg(json: trainingAvgDto)
                    
                    if trainingAvg != nil {
                        trainingAvgs?.append(trainingAvg!)
                    }
                }
            }
        }
        return trainingAvgs
    }
    
    override func initUrlTag() -> String {
        return "avgtraining/downloadBySessionIds"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    override func initParameters() -> Parameters? {
        return sessionIds.asParameters()
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.download_training_avg
    }
    
}
