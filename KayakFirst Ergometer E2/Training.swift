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

struct Training {
    
    //MARK: constants
    static let typeKayak = "kayak"
    static let typeCanoe = "canoe"
    static let typeDragonBoat = "dragon_boat"
    
    static let defaultDistance = -1.0
    
    let timeStamp: TimeInterval
    let currentDistance: Double
    let userId: Int64
    let sessionId: TimeInterval
    let trainingType: String
    let trainingEnvironmentType: TrainingEnvironmentType
    let dataType: String
    let dataValue: Double
}
