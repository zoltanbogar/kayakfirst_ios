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
    
    //MARK: properties
    private var sessionIdValue: Double?
    private var avgHashes: [String]?
    
    //MARK: keys
    struct PropertyKey {
        static let averageHashKey = "averageHash"
        static let userIdKey = "userId"
        static let dataTypeKey = "dataType"
        static let dataValueKey = "dataValue"
    }
    
    //MARK: columns
    private let averageHash = Expression<String>(PropertyKey.averageHashKey)
    private let userId = Expression<Int64>(PropertyKey.userIdKey)
    private let dataType = Expression<String>(PropertyKey.dataTypeKey)
    private let dataValue = Expression<Double>(PropertyKey.dataValueKey)
    
    //MARK: init database
    override func initDatabase() {
        table = Table("training_avg_table")
        do {
            if let database = db {
                try database.run(table!.create(ifNotExists: true) { t in
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
    
    //MARK: insert
    override func addData(data: TrainingAvg) {
        if sessionIdValue != data.sessionId {
            avgHashes = [String]()
            sessionIdValue = data.sessionId
        }
        
        if !avgHashes!.contains(data.avgHash) {
            avgHashes!.append(data.avgHash)
            
            let insert = table!.insert(self.averageHash <- data.avgHash, self.userId <- data.userId!, self.sessionId <- data.sessionId, self.dataType <- data.avgType, self.dataValue <- data.avgValue)
            
            let rowId = try? db?.run(insert)
        } else {
            updateData(trainingAvg: data)
        }
    }
    
    //MARK: query
    override func loadData(predicate: Expression<Bool>?) -> [TrainingAvg]? {
        var trainingAvgList: [TrainingAvg]?
        
        do {
            var queryPredicate = self.userId == UserService.sharedInstance.getUser()!.id
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            let dbList = try db!.prepare(table!.filter(queryPredicate))
            
            trainingAvgList = [TrainingAvg]()
            
            for trainingAvgDb in dbList {
                let userId = trainingAvgDb[self.userId]
                let sessionId = trainingAvgDb[self.sessionId]
                let avgType = trainingAvgDb[self.dataType]
                let avgValue = trainingAvgDb[self.dataValue]

                let trainingAvg = TrainingAvg(
                    userId: userId,
                    sessionId: sessionId,
                    avgType: avgType,
                    avgValue: avgValue)
                
                trainingAvgList?.append(trainingAvg)
                
            }
        } catch {
            log("DATABASE", error)
        }
        
        return trainingAvgList
    }
    
    //MARK: update
    private func updateData(trainingAvg: TrainingAvg) {
        let avg = table!.filter(self.averageHash == trainingAvg.avgHash)
        do {
            try db!.run(avg.update(self.dataValue <- trainingAvg.avgValue))
        } catch {
            log("DATABASE", error)
        }
    }
    
}
