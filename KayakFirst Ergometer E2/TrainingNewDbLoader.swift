//
//  TrainingNewDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingNewDbLoader: UploadAbleDbLoader<TrainingNew, Double> {
    
    //MARK: constants
    static let tableName = "training_table"
    
    //MARK: init
    static let sharedInstance = TrainingNewDbLoader()
    private override init() {
        super.init()
    }
    
    override func getTableName() -> String {
        return TrainingNewDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(baseId, primaryKey: .autoincrement)
            t.column(sessionId)
            t.column(timestamp)
            t.column(force)
            t.column(speed)
            t.column(distance)
            t.column(strokes)
            t.column(t200)
        })
    }
    
    //MARK: insert
    func addTrainings(trainings: [TrainingNew]) {
        do {
            try db!.transaction {
                for training in trainings {
                    self.addData(data: training)
                }
            }
        } catch {
            log(databaseLogTag, error)
        }
    }
    
    override func addData(data: TrainingNew?) {
        if let training = data {
            let insert = table!.insert(self.sessionId <- Double(Int64(training.sessionId)), self.timestamp <- Double(Int64(training.timestamp)), self.force <- training.force, self.speed <- training.speed, self.distance <- training.distance, self.strokes <- training.strokes, self.t200 <- training.t200)
            
            let rowId = try? db?.run(insert)
        }
    }
    
    //MARK: update
    override func updateData(data: TrainingNew) {
        //nothing here
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
    
    //MARK: query
    override func queryData(predicate: Expression<Bool>?) -> [TrainingNew]? {
        return loadData(predicate: predicate)
    }
    
    func getTrainingsBySessionId(sessionId: Double) -> [TrainingNew]? {
        return loadData(predicate: getPredicateSessionId(sessionId: sessionId))
    }
    
    override func loadData(predicate: Expression<Bool>?) -> [TrainingNew]? {
        var trainingList: [TrainingNew]?
        
        do {
            var queryPredicate = self.sessionId > 0
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            let dbList = try db!.prepare(table!.filter(queryPredicate).order(self.timestamp))
            
            trainingList = [TrainingNew]()
            
            for trainingDb in dbList {
                let sessionId = trainingDb[self.sessionId]
                let timestamp = trainingDb[self.timestamp]
                let force = trainingDb[self.force]
                let speed = trainingDb[self.speed]
                let distance = trainingDb[self.distance]
                let strokes = trainingDb[self.strokes]
                let t200 = trainingDb[self.t200]
                
                let training = TrainingNew(
                    sessionId: sessionId,
                    force: force,
                    speed: speed,
                    strokes: strokes,
                    t200: t200,
                    timestamp: timestamp,
                    distance: distance)
                
                trainingList?.append(training)
                
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return trainingList
    }
    
    override func getDeleteOldDataPredicate() -> Expression<Bool> {
        return self.sessionId < getOldDataTimestamp(oldDataDays: oldDataDays)
    }
    
    //MARK: protocol
    override func loadUploadAbleData(pointer: Double) -> [TrainingNew]? {
        let predicate = self.timestamp > pointer
        return loadData(predicate: predicate)
    }
    
    func loadUploadAbleData(sessionId: Double, timestampPointer: Double) -> [TrainingNew]? {
        let predicateTimestamp = self.timestamp > timestampPointer
        let predicateSessionId = self.sessionId == sessionId
        return loadData(predicate: getSumPredicate(predicates: predicateTimestamp, predicateSessionId))
    }
    
    func getPredicateSessionId(sessionId: Double) -> Expression<Bool> {
        return self.sessionId == sessionId
    }
}
