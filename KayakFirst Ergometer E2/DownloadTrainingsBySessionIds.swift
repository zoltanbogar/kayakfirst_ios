//
//  DownloadTrainingsBySessionId.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 20..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadTrainingsBySessionIds: ServerService<[TrainingNew]> {
    
    private let sessionIds: [Double]
    
    //TODO: maybe: Double(Int64(sessionId))
    init(sessionIds: [Double]) {
        self.sessionIds = sessionIds
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [TrainingNew]? {
        var trainings: [TrainingNew]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            if let jsonArray = jsonValue.array {
                trainings = [TrainingNew]()
                
                for trainingDto in jsonArray {
                    let training = TrainingNew(json: trainingDto)
                    
                    if training != nil {
                        trainings?.append(training!)
                    }
                }
            }
        }
        return trainings
    }
    
    override func initUrlTag() -> String {
        return "training/downloadBySessionIds"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initEncoding() -> ParameterEncoding {
        return ArrayEncoding()
    }
    
    override func initParameters() -> Parameters? {
        return [
            "sessionIds": sessionIds
        ]
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.download_training
    }
    
}
