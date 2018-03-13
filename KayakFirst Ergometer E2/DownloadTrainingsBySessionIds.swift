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

class DownloadTrainingsBySessionIds: ServerService<[Training]> {
    
    private let sessionIds: [Double]
    
    init(sessionIds: [Double]) {
        self.sessionIds = sessionIds
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [Training]? {
        var trainings: [Training]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            if let jsonArray = jsonValue.array {
                trainings = [Training]()
                
                for trainingDto in jsonArray {
                    let training = Training(json: trainingDto)
                    
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
        return sessionIds.asParameters()
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.download_training
    }
    
}
