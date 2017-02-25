//
//  TrainingDaysDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingDaysDbLoader: BaseDbLoader<Int64> {
    
    //MARK: keys
    struct PropertyKey {
        static let sessionIdKey = "sessionId"
        static let userIdKey = "userId"
    }
    
    //MARK: columns
    private let trainingDaysTable = Table("training_days_table")
    private let sessionId = Expression<Double>(PropertyKey.sessionIdKey)
    private let userId = Expression<Int64>(PropertyKey.userIdKey)
    
    //MARK: init database
    override func initDatabase() {
        do {
            if let database = db {
                try database.run(trainingDaysTable.create(ifNotExists: true) { t in
                    t.column(sessionId, primaryKey: true)
                    t.column(userId)
                })
            }
        } catch {
            log("DATABASE", error)
        }
    }
}
