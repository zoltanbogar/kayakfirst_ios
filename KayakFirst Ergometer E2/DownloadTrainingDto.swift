//
//  DownloadTrainingDto.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DownloadTrainingDto {
    
    let timeStamp: TimeInterval
    let dataType: String
    let dataValue: Double
    let currentDistance: Double
    
    init(json: JSON) {
        self.timeStamp = json["timestamp"].doubleValue
        self.dataType = json["dataType"].stringValue
        self.dataValue = json["dataValue"].doubleValue
        self.currentDistance = json["currentDistance"].doubleValue
    }
    
}
