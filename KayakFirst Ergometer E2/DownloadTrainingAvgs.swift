//
//  DownloadTrainingAvgs.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadTrainingAvgs: ServerService<[TrainingAvg]> {
    
    let sessionIdFrom: TimeInterval
    let sessionIdTo: TimeInterval
    
    init(sessionIdFrom: TimeInterval, sessionIdTo: TimeInterval) {
        self.sessionIdFrom = sessionIdFrom
        self.sessionIdTo = sessionIdTo
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [TrainingAvg]? {
        var trainingAvgList: [TrainingAvg]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            if let jsonArray = jsonValue.array {
                 let userId = UserService.sharedInstance.getUser()!.id
                
                trainingAvgList = [TrainingAvg]()
                
                for downloadDtoJson in jsonArray {
                    let downloadDto = TrainingAvgDtoDownload(json: downloadDtoJson)
                    let trainingAvg = TrainingAvg(
                        userId: userId,
                        sessionId: downloadDto.sessionId,
                        avgType: downloadDto.dataType,
                        avgValue: downloadDto.dataValue)
                    
                    trainingAvgList?.append(trainingAvg)
                }
            }
        }
        return trainingAvgList
    }
    
    override func initUrlTag() -> String {
        return "avgtraining/download"
    }
    
    override func initMethod() -> HTTPMethod {
        return .post
    }
    
    override func initParameters() -> Parameters? {
        return [
            "sessionIdFrom": sessionIdFrom,
            "sessionIdTo": sessionIdTo
        ]
    }
    
    override func initEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    override func isEqual(anotherServerService: ServerService<[TrainingAvg]>) -> Bool {
        if let service = anotherServerService as? DownloadTrainingAvgs {
            return (service.sessionIdTo == self.sessionIdTo) && (service.sessionIdFrom == self.sessionIdFrom)
        } else {
            return false
        }
    }
    
    override func getManagerType() -> BaseManagerType {
        return TrainingManagerType.download_training_avg
    }
    
}
