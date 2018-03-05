//
//  TrainingAvgNewDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingAvgNewDbLoader: UploadAbleDbLoader<TrainingAvgNew, Double> {
    
    //MARK: constants
    static let tableName = "training_avg_table"
    
    //MARK: properties
    private var sessionIdValue: Double?
    
    //MARK: init
    static let sharedInstance = TrainingAvgNewDbLoader()
    private override init() {
        super.init()
    }
    
    override func getTableName() -> String {
        return TrainingAvgNewDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(baseId, primaryKey: .autoincrement)
            t.column(sessionId)
            t.column(force)
            t.column(speed)
            t.column(strokes)
            t.column(t200)
        })
    }
    
    //MARK: insert
    func addTrainingAvgs(trainingAvgs: [TrainingAvgNew]) {
        do {
            try db!.transaction {
                for trainingAvg in trainingAvgs {
                    self.addData(data: trainingAvg)
                }
            }
        } catch {
            log(databaseLogTag, error)
        }
    }
    
    override func addData(data: TrainingAvgNew?) {
        if let trainingAvg = data {
            if sessionIdValue != trainingAvg.sessionId {
                sessionIdValue = trainingAvg.sessionId
                
                let insert = table!.insert(self.sessionId <- Double(Int64(trainingAvg.sessionId)), self.force <- trainingAvg.force, self.speed <- trainingAvg.speed, self.strokes <- trainingAvg.strokes, self.t200 <- trainingAvg.t200)
                
                let rowId = try? db?.run(insert)
            } else {
                updateData(trainingAvg: trainingAvg)
            }
        }
    }
    
    //MARK: query
    func getTrainingAvgBySessionId(sessionId: Double) -> TrainingAvgNew? {
        let trainingAvgs = loadData(predicate: getPredicateSessionId(sessionId: sessionId))
        
        if trainingAvgs != nil && trainingAvgs!.count > 0 {
            return trainingAvgs?[0]
        }
        return nil
    }
    
    func getTrainingAvgsBetweenSessionIdPredicate(sessionIdFrom: Double, sessionIdTo: Double) -> Expression<Bool> {
        return self.sessionId >= sessionIdFrom && self.sessionId <= sessionIdTo
    }
    
    func getSessionIdPredicate(sessionId: Double) -> Expression<Bool> {
        return self.sessionId == sessionId
    }
    
    override func loadData(predicate: Expression<Bool>?) -> [TrainingAvgNew]? {
        var trainingAvgList: [TrainingAvgNew]?
        
        do {
            var queryPredicate = self.sessionId > 0
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            log("DB_TEST", "\(predicate)")
            
            let dbList = try db!.prepare(table!.filter(queryPredicate))
            
            trainingAvgList = [TrainingAvgNew]()
            
            for trainingAvgDb in dbList {
                let sessionId = trainingAvgDb[self.sessionId]
                let force = trainingAvgDb[self.force]
                let speed = trainingAvgDb[self.speed]
                let strokes = trainingAvgDb[self.strokes]
                let t200 = trainingAvgDb[self.t200]
                
                let trainingAvg = TrainingAvgNew(
                    sessionId: sessionId,
                    force: force,
                    speed: speed,
                    strokes: strokes,
                    t200: t200)
                
                trainingAvgList?.append(trainingAvg)
                
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return trainingAvgList
    }
    
    //MARK: protocol
    override func loadUploadAbleData(pointer: Double) -> [TrainingAvgNew]? {
        let predicate = self.sessionId == pointer
        return loadData(predicate: predicate)
    }
    
    func loadUploadAbleData(sessionIds: [Double]?) -> [TrainingAvgNew]? {
        if let sessionIds = sessionIds {
            return loadData(predicate: getSumPredicateOr(column: self.sessionId, values: sessionIds))
        }
        return nil
    }
    
    //MARK: update
    private func updateData(trainingAvg: TrainingAvgNew) {
        let avg = table!.filter(self.sessionId == Double(Int64(trainingAvg.sessionId)))
        do {
            try db!.run(avg.update(self.force <- trainingAvg.force, self.speed <- trainingAvg.speed, self.strokes <- trainingAvg.strokes, self.t200 <- trainingAvg.t200))
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
    
    override func getDeleteOldDataPredicate() -> Expression<Bool> {
        return self.sessionId < getOldDataTimestamp(oldDataDays: oldDataDays)
    }
    
    private func getPredicateSessionId(sessionId: Double) -> Expression<Bool> {
        return self.sessionId == sessionId
    }
    
    private func getSumPredicateOr(column: Expression<Double>, values: [Double]?) -> Expression<Bool>? {
        var sumPredicate: Expression<Bool>? = nil
        if let values = values {
            for value in values {
                let predicate: Expression<Bool> = column == value
                if sumPredicate == nil {
                    sumPredicate = predicate
                } else {
                    sumPredicate = sumPredicate! || predicate
                }
            }
        }
        return sumPredicate
    }
    
}
