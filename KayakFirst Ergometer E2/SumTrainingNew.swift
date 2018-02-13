//
//  SumTrainingNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum TrainingEnvironmentType: String {
    case ergometer = "ergometer"
    case outdoor = "outdoor"
}

enum ArtOfPaddle: String {
    case racingKayaking = "racing_kayaking"
    case racingCanoeing = "racing_canoeing"
    case recreationalKayaking = "recreational_kayaking"
    case recreationalCanoeing = "recreational_canoeing"
    case sup = "sup"
    case dragon = "dragon"
    case rowing = "rowing"
}

func createSumTraining(sessionId: Double, trainingEnvType: TrainingEnvironmentType, planTrainingId: String, planTrainingType: PlanType) {
    //TODO: add implementation
}

class SumTrainingNew: Equatable, ModifyAble {
    
    //MARK: constants
    private let oneHourMilliseconds: TimeInterval = 60 * 60 * 1000
    
    let sessionId: Double
    let userId: Int64
    let artOfPaddle: ArtOfPaddle
    let trainingEnvironmentType: TrainingEnvironmentType
    var trainingCount: Int
    let planTrainingId: String
    let planTrainingType: PlanType
    let startTime: Double
    var duration: Double
    var distance: Double
    
    var formattedStartTime: String {
        get {
            return DateFormatHelper.getDate(dateFormat: DateFormatHelper.timeFormat, timeIntervallSince1970: startTime)
        }
    }
    
    var formattedDuration: String {
        get {
            var format = TimeEnum.timeFormatTwo
            
            if duration > oneHourMilliseconds {
                format = TimeEnum.timeFormatThree
            }
            
            return DateFormatHelper.getTime(millisec: duration, format: format)!
        }
    }
    
    var formattedDistance: String {
        get {
            return String(format: "%.0f", UnitHelper.getDistanceValue(metricValue: distance)) + " " + UnitHelper.getDistanceUnit()
        }
    }
    
    init(sessionId: Double, userId: Int64, artOfPaddle: ArtOfPaddle, trainingEnvironmentType: TrainingEnvironmentType, trainingCount: Int, planTrainingId: String, planTrainingType: PlanType, startTime: Double, duration: Double, distance: Double) {
        self.sessionId = sessionId
        self.userId = userId
        self.artOfPaddle = artOfPaddle
        self.trainingEnvironmentType = trainingEnvironmentType
        self.trainingCount = trainingCount
        self.planTrainingId = planTrainingId
        self.planTrainingType = planTrainingType
        self.startTime = startTime
        self.duration = duration
        self.distance = distance
    }
    
    //MARK: protocol
    static func == (lhs: SumTrainingNew, rhs: SumTrainingNew) -> Bool {
        return Int64(lhs.sessionId) == Int64(rhs.sessionId)
    }
    
    func getUploadPointer() -> String {
        return "\(sessionId)"
    }
    
    func getParameters() -> [String : Any] {
        return [
            "sessionId":"\(Int64(sessionId))",
            "userId":"\(Int64(userId))",
            "artOfPaddle":"\(artOfPaddle.rawValue)",
            "trainingEnvironmentType":"\(trainingEnvironmentType.rawValue)",
            "trainingCount":"\(trainingCount)",
            "planTrainingId":"\(planTrainingId)",
            "planTrainingType":"\(planTrainingType.rawValue)",
            "startTime":"\(startTime)",
            "duration":"\(duration)",
            "distance":"\(distance)"
        ]
    }
    
    
}
