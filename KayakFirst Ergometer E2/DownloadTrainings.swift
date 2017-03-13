//
//  DownloadTrainings.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DownloadTrainings: ServerService<[Training]> {
    
    private let sessionIdFrom: TimeInterval
    private let sessionIdTo: TimeInterval
    
    init(sessionIdFrom: TimeInterval, sessionIdTo: TimeInterval) {
        self.sessionIdFrom = sessionIdFrom
        self.sessionIdTo = sessionIdTo
    }
    
    override func handleServiceCommunication(alamofireRequest: DataRequest) -> [Training]? {
        var trainingList: [Training]?
        let response = alamofireRequest.responseJSON()
        
        if let json = response.result.value {
            let jsonValue = JSON(json)
            
            if let jsonArray = jsonValue.array {
                
                //TODO: it can be nil
                let userId = UserService.sharedInstance.getUser()!.id
                trainingList = [Training]()
                
                for downloadDtoJson in jsonArray {
                    let downloadDto = DownloadDto(json: downloadDtoJson)
                    
                    let sessionId = downloadDto.sessionId
                    let trainingType = downloadDto.traningType
                    
                    for downloadTrainingDto in downloadDto.data {
                        let timeStamp = downloadTrainingDto.timeStamp
                        let dataType = downloadTrainingDto.dataType
                        let dataValue = downloadTrainingDto.dataValue
                        let currentDistance = downloadTrainingDto.currentDistance
                        
                        if timeStamp != 0 {
                            let training = Training(
                                timeStamp: timeStamp,
                                currentDistance: currentDistance,
                                userId: userId,
                                sessionId: sessionId,
                                trainingType: TrainingType(rawValue: trainingType)!,
                                trainingEnvironmentType: TrainingEnvironmentType(rawValue: downloadDto.trainingEnvironmentType) == nil ? TrainingEnvironmentType.ergometer : TrainingEnvironmentType(rawValue: downloadDto.trainingEnvironmentType)!,
                                dataType: dataType,
                                dataValue: dataValue)
                            trainingList?.append(training)
                        }
                    }
                }
            }
        }
        
        return trainingList
    }
    
    override func initUrlTag() -> String {
        return "training/download"
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
    
}
