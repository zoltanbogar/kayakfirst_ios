//
//  TrainingAvgDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingAvgDbLoader: UploadAbleDbLoader<TrainingAvg, Double> {
    
    //MARK: constants
    static let tableName = "training_avg_table"
    
    //MARK: properties
    private var sessionIdValue: Double?
    private var avgHashes: [String]?
    
    //MARK: init
    static let sharedInstance = TrainingAvgDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let averageHashKey = "averageHash"
        static let dataTypeKey = "dataType"
        static let dataValueKey = "dataValue"
    }
    
    //MARK: columns
    private let averageHash = Expression<String>(PropertyKey.averageHashKey)
    private let dataType = Expression<String>(PropertyKey.dataTypeKey)
    private let dataValue = Expression<Double>(PropertyKey.dataValueKey)
    
    override func getTableName() -> String {
        return TrainingAvgDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(averageHash, primaryKey: true)
            t.column(userId)
            t.column(sessionId)
            t.column(dataType)
            t.column(dataValue)
        })
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
    func getTrainingAvgsBetweenSessionIdPredicate(sessionIdFrom: Double, sessionIdTo: Double) -> Expression<Bool> {
        return self.sessionId > sessionIdFrom && self.sessionId <= sessionIdTo
    }
    
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
            log(databaseLogTag, error)
        }
        
        return trainingAvgList
    }
    
    //MARK: protocol
    override func loadUploadAbleData(pointer: Double) -> [TrainingAvg]? {
        let telemetry = Telemetry.sharedInstance
        let predicate = self.sessionId == pointer && self.sessionId != telemetry.sessionId
        return loadData(predicate: predicate)
    }
    
    //MARK: update
    private func updateData(trainingAvg: TrainingAvg) {
        let avg = table!.filter(self.averageHash == trainingAvg.avgHash)
        do {
            try db!.run(avg.update(self.dataValue <- trainingAvg.avgValue))
        } catch {
            log(databaseLogTag, error)
        }
    }
    
    //MARK: delete
    override func deleteData(predicate: Expression<Bool>?) -> Int {
        var deletedRows = 0
        
        let deleteData = table!.filter(predicate!)
        
        do {
            deletedRows = try db!.run(deleteData.delete())
        } catch {
            log(databaseLogTag, error)
        }
        return deletedRows
    }
    
}
