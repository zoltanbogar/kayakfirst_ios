//
//  DownloadDto.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DownloadDto {
    
    let id: Int64
    let sessionId: Int64
    let traningType: String
    let data: [DownloadTrainingDto]
    
    init(json: JSON) {
        self.id = json["id"].int64Value
        self.sessionId = json["sessionId"].int64Value
        self.traningType = json["trainingType"].stringValue
        
        var downloadTrainingDtos = [DownloadTrainingDto]()
        
        for downloadTrainingDtoJson in json["data"].array! {
            downloadTrainingDtos.append(DownloadTrainingDto(json: downloadTrainingDtoJson))
        }
        
        data = downloadTrainingDtos
    }
    
}
