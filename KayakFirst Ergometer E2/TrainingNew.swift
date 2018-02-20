//
//  TrainingNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

func createTraining(timestamp: Double, force: Double, speed: Double, distance: Double, strokes: Double, t200: Double) -> TrainingNew {
    let sessionId = Telemetry.sharedInstance.sessionId
    
    return TrainingNew(
        sessionId: sessionId,
        force: force,
        speed: speed,
        strokes: strokes,
        t200: t200,
        timestamp: timestamp,
        distance: distance)
}

class TrainingNew: BaseTraining, UploadAble {
    typealias E = Double
    
    let timestamp: Double
    let distance: Double
    
    init(sessionId: Double, force: Double, speed: Double, strokes: Double, t200: Double, timestamp: Double, distance: Double) {
        self.timestamp = timestamp
        self.distance = distance
        
        super.init(sessionId: sessionId, force: force, speed: speed, strokes: strokes, t200: t200)
    }
    
    override init?(json: JSON) {
        self.timestamp = json["timestamp"].doubleValue
        self.distance = json["distance"].doubleValue
        
        super.init(json: json)
    }
    
    func getUploadPointer() -> Double {
        return timestamp
    }
    
    func getParameters() -> [String : Any] {
        return [
            "sessionId":"\(Int64(sessionId))",
            "timestamp":"\(Int64(timestamp))",
            "force":"\(force)",
            "speed":"\(speed)",
            "distance":"\(distance)",
            "strokes":"\(strokes)",
            "t200":"\(t200)"
        ]
    }
}
