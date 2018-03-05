//
//  DownloadTrainingDays.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadTrainingDays: ServerService<[TimeInterval]> {
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [TimeInterval]? {
        var trainingDays: [TimeInterval]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            trainingDays = [TimeInterval]()
            
            for trainingDay in jsonValue.arrayObject! {
                trainingDays?.append(TimeInterval(trainingDay as! String)!)
            }
        }
        return trainingDays
    }
    
    override func initUrlTag() -> String {
        return "training/downloadDays"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "timestampFrom": 0,
            "timestampTo": Double(INT64_MAX)
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.download_training_days
    }
    
}
