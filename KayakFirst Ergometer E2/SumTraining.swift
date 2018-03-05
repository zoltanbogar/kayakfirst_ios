//
//  SumTrainingNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

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

func createSumTraining(sessionId: Double, trainingEnvType: String, planTrainingId: String, planTrainingType: PlanType?) -> SumTraining {
    
    let userManager = UserManager.sharedInstance
    let userId = userManager.getUserId()
    let paddleOfArt = userManager.getArtOfPaddle()
    
    return SumTraining(
        sessionId: sessionId,
        userId: userId,
        artOfPaddle: paddleOfArt,
        trainingEnvironmentType: trainingEnvType,
        trainingCount: 0,
        planTrainingId: planTrainingId,
        planTrainingType: planTrainingType,
        startTime: sessionId,
        duration: 0,
        distance: 0)
    
}

class SumTraining: Equatable, ModifyAble {
    
    //MARK: constants
    private let oneHourMilliseconds: TimeInterval = 60 * 60 * 1000
    
    let sessionId: Double
    let userId: Int64
    let artOfPaddle: String
    let trainingEnvironmentType: String
    var trainingCount: Int
    let planTrainingId: String
    let planTrainingType: PlanType?
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
    
    init(sessionId: Double, userId: Int64, artOfPaddle: String, trainingEnvironmentType: String, trainingCount: Int, planTrainingId: String, planTrainingType: PlanType?, startTime: Double, duration: Double, distance: Double) {
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
    
    init?(json: JSON) {
        self.sessionId = json["sessionId"].doubleValue
        self.userId = json["userId"].int64Value
        self.artOfPaddle = json["artOfPaddle"].stringValue
        self.trainingEnvironmentType = json["trainingEnvironmentType"].stringValue
        self.trainingCount = json["trainingCount"].intValue
        self.planTrainingId = json["planTrainingId"].stringValue
        self.planTrainingType = PlanType(rawValue: json["planTrainingType"].stringValue)
        self.startTime = json["startTime"].doubleValue
        self.duration = json["duration"].doubleValue
        self.distance = json["distance"].doubleValue
    }
    
    //MARK: protocol
    static func == (lhs: SumTraining, rhs: SumTraining) -> Bool {
        return Int64(lhs.sessionId) == Int64(rhs.sessionId)
    }
    
    func getUploadPointer() -> String {
        return "\(sessionId)"
    }
    
    func getParameters() -> [String : Any] {
        let planType = planTrainingType != nil ? planTrainingType!.rawValue : ""
        return [
            "sessionId":"\(Int64(sessionId))",
            "userId":"\(Int64(userId))",
            "artOfPaddle":"\(artOfPaddle)",
            "trainingEnvironmentType":"\(trainingEnvironmentType)",
            "trainingCount":"\(trainingCount)",
            "planTrainingId":"\(planTrainingId)",
            "planTrainingType":"\(planType)",
            "startTime":"\(startTime)",
            "duration":"\(duration)",
            "distance":"\(distance)"
        ]
    }
    
    
}
