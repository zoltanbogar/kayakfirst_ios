//
//  DownloadSumTrainingsBySessionIds.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 20..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadSumTrainingsBySessionIds: ServerService<[SumTraining]> {
    
    private let sessionIds: [Double]
    
    init(sessionIds: [Double]) {
        self.sessionIds = sessionIds
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [SumTraining]? {
        var trainingSums: [SumTraining]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            if let jsonArray = jsonValue.array {
                trainingSums = [SumTraining]()
                
                for trainingSumDto in jsonArray {
                    let trainingSum = SumTraining(json: trainingSumDto)
                    
                    if trainingSum != nil {
                        trainingSums?.append(trainingSum!)
                    }
                }
            }
        }
        return trainingSums
    }
    
    override func initUrlTag() -> String {
        return "training/downloadSumTrainings"
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
        return TrainingManagerType.download_training_sum
    }
    
}
