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

class DownloadSumTrainingsBySessionIds: ServerService<[SumTrainingNew]> {
    
    private let sessionIds: [Double]
    
    //TODO: maybe: Double(Int64(sessionId))
    init(sessionIds: [Double]) {
        self.sessionIds = sessionIds
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [SumTrainingNew]? {
        var trainingSums: [SumTrainingNew]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            if let jsonArray = jsonValue.array {
                trainingSums = [SumTrainingNew]()
                
                for trainingSumDto in jsonArray {
                    let trainingSum = SumTrainingNew(json: trainingSumDto)
                    
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
