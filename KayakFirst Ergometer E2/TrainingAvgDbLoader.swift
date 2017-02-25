//
//  TrainingAvgDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingAvgDbLoader: BaseDbLoader<TrainingAvg> {
    
    //MARK: keys
    struct PropertyKey {
        static let averageHashKey = "averageHash"
        static let userIdKey = "userId"
        static let sessionIdKey = "sessionId"
        static let dataTypeKey = "dataType"
        static let dataValueKey = "dataValue"
    }
    
    //MARK: columns
    private let trainingAvgTable = Table("training_avg_table")
    private let averageHash = Expression<String>(PropertyKey.averageHashKey)
    private let userId = Expression<Int64>(PropertyKey.userIdKey)
    private let sessionId = Expression<Double>(PropertyKey.sessionIdKey)
    private let dataType = Expression<String>(PropertyKey.dataTypeKey)
    private let dataValue = Expression<Double>(PropertyKey.dataValueKey)
    
    //MARK: init database
    override func initDatabase() {
        do {
            if let database = db {
                try database.run(trainingAvgTable.create(ifNotExists: true) { t in
                    t.column(averageHash, primaryKey: true)
                    t.column(userId)
                    t.column(sessionId)
                    t.column(dataType)
                    t.column(dataValue)
                })
            }
        } catch {
            log("DATABASE", error)
        }
    }
    
}
