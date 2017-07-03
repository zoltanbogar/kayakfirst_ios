//
//  TrainingAvg.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

struct TrainingAvg: UploadAble {
    typealias E = String
    
    var avgHash: String
    var userId: Int64?
    var sessionId: TimeInterval
    var avgType: String
    var avgValue: Double
    
    init(userId: Int64?, sessionId: TimeInterval, avgType: String, avgValue: Double) {
        self.userId = userId
        self.sessionId = sessionId
        self.avgType = avgType
        self.avgValue = avgValue
        
        avgHash = TrainingAvg.getAvgHash(userId: userId, avgType: avgType, sessionId: sessionId)
    }
    
    static func getAvgHash(userId: Int64?, avgType: String, sessionId: TimeInterval) -> String {
        return "\(sessionId)" + avgType + "\(userId ?? 0)"
    }
    
    func getUploadPointer() -> String {
        return avgHash
    }
    
    func getParameters() -> [String : Any] {
        return [
            "userId":"\(userId))",
            "sessionId":"\(Int64(sessionId))",
            "avgType":"\(avgType)",
            "avgValue":"\(avgValue)"
        ]
    }
}
