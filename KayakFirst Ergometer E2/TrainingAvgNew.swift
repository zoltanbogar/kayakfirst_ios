//
//  TrainingAvgNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func createTrainingAvg(force: Double, speed: Double, strokes: Double, t200: Double) -> TrainingAvgNew {
    let sessionId = Telemetry.sharedInstance.sessionId
    
    return TrainingAvgNew(
        sessionId: sessionId,
        force: force,
        speed: speed,
        strokes: strokes,
        t200: t200)
}

class TrainingAvgNew: BaseTraining, UploadAble {
    typealias E = Double
    
    func getUploadPointer() -> Double {
        return sessionId
    }
    
    func getParameters() -> [String : Any] {
        return [
            "sessionId":"\(Int64(sessionId))",
            "force":"\(force)",
            "speed":"\(speed)",
            "strokes":"\(strokes)",
            "t200":"\(t200)"
        ]
    }
}
