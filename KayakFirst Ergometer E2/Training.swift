//
//  Training.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum TrainingEnvironmentType: String {
    case ergometer = "ergometer"
    case outdoor = "outdoor"
}

enum TrainingType: String {
    case kayak = "kayak"
    case canoe = "canoe"
    case dragonBoat = "dragonBoat"
}

struct Training: UploadAble {
    typealias E = Double
    
    static let defaultDistance = -1.0
    
    var timeStamp: TimeInterval = 0
    var currentDistance: Double = 0
    var userId: Int64? = nil
    var sessionId: TimeInterval = 0
    var trainingType: TrainingType = TrainingType.kayak
    var trainingEnvironmentType: TrainingEnvironmentType = TrainingEnvironmentType.outdoor
    var dataType: String = ""
    var dataValue: Double = 0
    
    init() {
        //empty constructor
    }
    
    init(
        timeStamp: TimeInterval,
        currentDistance: Double,
        userId: Int64?,
        sessionId: TimeInterval,
        trainingType: TrainingType,
        trainingEnvironmentType: TrainingEnvironmentType,
        dataType: String,
        dataValue: Double) {
        self.timeStamp = timeStamp
        self.currentDistance = currentDistance
        self.userId = userId
        self.sessionId = sessionId
        self.trainingType = trainingType
        self.trainingEnvironmentType = trainingEnvironmentType
        self.dataType = dataType
        self.dataValue = dataValue
    }
    
    func getUploadPointer() -> Double {
        return timeStamp
    }
}
