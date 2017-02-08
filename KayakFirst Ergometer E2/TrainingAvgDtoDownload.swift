//
//  TrainingAvgDtoDownload.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TrainingAvgDtoDownload {
    
    var id: Int64
    var sessionId: TimeInterval
    var dataType: String
    var dataValue: Double
    
    init(json: JSON) {
        self.id = json["id"].int64Value
        self.sessionId = json["sessionId"].doubleValue
        self.dataType = json["dataType"].stringValue
        self.dataValue = json["dataValue"].doubleValue
    }
    
}
