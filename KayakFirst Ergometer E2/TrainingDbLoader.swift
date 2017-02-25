//
//  TrainingDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingDbLoader: BaseDbLoader<Training> {
    
    //MARK: keys
    struct PropertyKey {
        static let timeStampKey = "timeStamp"
        static let currentDistanceKey = "currentDistance"
        static let userIdKey = "userId"
        static let sessionIdKey = "sessionId"
        static let trainingTypeKey = "trainingType"
        static let trainingEnvironmentTypeKey = "trainingEnvironmentType"
        static let dataTypeKey = "dataType"
        static let dataValueKey = "dataValueKey"
    }
    
    //MARK: columns
    private let trainingTable = Table("training_table")
    private let timeStamp = Expression<Int64>(PropertyKey.timeStampKey)
    private let currentDistance = Expression<Double>(PropertyKey.currentDistanceKey)
    private let userId = Expression<Int64>(PropertyKey.userIdKey)
    private let sessionId = Expression<Double>(PropertyKey.sessionIdKey)
    private let trainigType = Expression<String>(PropertyKey.trainingTypeKey)
    private let trainingEnvironmentType = Expression<String>(PropertyKey.trainingEnvironmentTypeKey)
    private let dataType = Expression<String>(PropertyKey.dataTypeKey)
    private let dataValue = Expression<Double>(PropertyKey.dataValueKey)
    
    //MARK: init database
    override func initDatabase() {
        do {
            if let database = db {
                try database.run(trainingTable.create(ifNotExists: true) { t in
                    t.column(timeStamp, primaryKey: true)
                    t.column(currentDistance)
                    t.column(userId)
                    t.column(sessionId)
                    t.column(trainigType)
                    t.column(trainingEnvironmentType)
                    t.column(dataType)
                    t.column(dataValue)
                })
            }
        } catch {
            log("DATABASE", error)
        }
    }
}
