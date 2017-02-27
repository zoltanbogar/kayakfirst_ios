//
//  TrainingDaysDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingDaysDbLoader: BaseDbLoader<Double> {
    
    //MARK: keys
    struct PropertyKey {
        static let userIdKey = "userId"
    }
    
    //MARK: columns
    private let userId = Expression<Int64>(PropertyKey.userIdKey)
    
    //MARK: init database
    override func initDatabase() {
        table = Table("training_days_table")
        do {
            if let database = db {
                try database.run(table!.create(ifNotExists: true) { t in
                    t.column(sessionId, primaryKey: true)
                    t.column(userId)
                })
            }
        } catch {
            log("DATABASE", error)
        }
    }
    
    //MARK: insert
    override func addData(data: Double) {
        let insert = table!.insert(self.sessionId <- data, self.userId <- UserService.sharedInstance.getUser()!.id)
        
        let rowId = try? db?.run(insert)
    }
    
    //MARK: query
    override func loadData(predicate: Expression<Bool>?) -> [Double]? {
        var trainingDaysList: [Double]?
        
        do {
            var queryPredicate = self.userId == UserService.sharedInstance.getUser()!.id
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            let dbList = try db!.prepare(table!.filter(queryPredicate))
            
            trainingDaysList = [Double]()
            
            for trainingDaysDb in dbList {
                let sessionId = trainingDaysDb[self.sessionId]
                
                trainingDaysList?.append(sessionId)
                
            }
        } catch {
            log("DATABASE", error)
        }
        
        return trainingDaysList
    }
}
