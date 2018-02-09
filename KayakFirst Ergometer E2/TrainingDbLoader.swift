//
//  TrainingDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingDbLoader: UploadAbleDbLoader<Training, Double> {
    
    //MARK: constants
    static let tableName = "training_table"
    
    //MARK: init
    static let sharedInstance = TrainingDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let timeStampKey = "timeStamp"
        static let currentDistanceKey = "currentDistance"
        static let trainingTypeKey = "trainingType"
        static let trainingEnvironmentTypeKey = "trainingEnvironmentType"
        static let dataTypeKey = "dataType"
        static let dataValueKey = "dataValueKey"
    }
    
    //MARK: columns
    private let timeStamp = Expression<Double>(PropertyKey.timeStampKey)
    private let currentDistance = Expression<Double>(PropertyKey.currentDistanceKey)
    private let trainingType = Expression<String>(PropertyKey.trainingTypeKey)
    private let trainingEnvironmentType = Expression<String>(PropertyKey.trainingEnvironmentTypeKey)
    private let dataType = Expression<String>(PropertyKey.dataTypeKey)
    private let dataValue = Expression<Double>(PropertyKey.dataValueKey)
    
    override func getTableName() -> String {
        return TrainingDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(timeStamp, primaryKey: true)
            t.column(currentDistance)
            t.column(userId)
            t.column(sessionId)
            t.column(trainingType)
            t.column(trainingEnvironmentType)
            t.column(dataType)
            t.column(dataValue)
        })
    }
    
    //MARK: insert
    func addTrainings(trainings: [Training]) {
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
    
    override func addData(data: Training?) {
        if let training = data {
            let insert = table!.insert(self.timeStamp <- Double(Int64(training.timeStamp)), self.currentDistance <- training.currentDistance, self.userId <- training.userId!, self.sessionId <- Double(Int64(training.sessionId)), self.trainingType <- training.trainingType.rawValue, self.trainingEnvironmentType <- training.trainingEnvironmentType.rawValue, self.dataType <- training.dataType, self.dataValue <- training.dataValue)
            
            let rowId = try? db?.run(insert)
        }
    }
    
    //MARK: update
    override func updateData(data: Training) {
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
    override func queryData(predicate: Expression<Bool>?) -> [Training]? {
        return loadData(predicate: predicate)
    }
    
    func getSessionIds() -> [Double] {
        var trainingDays = [Double]()
        
        do {
            let query = table?.select(distinct: self.sessionId).order(self.sessionId)
            
            let dbList = try db!.prepare(query!.filter(getUserQuery()))
            
            for days in dbList {
                trainingDays.append(days[self.sessionId])
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return trainingDays
    }
    
    override func loadData(predicate: Expression<Bool>?) -> [Training]? {
        var trainingList: [Training]?
        
        do {
            var queryPredicate = self.userId == UserManager.sharedInstance.getUser()!.id
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            let dbList = try db!.prepare(table!.filter(queryPredicate).order(self.timeStamp))
            
            trainingList = [Training]()
            
            for trainingDb in dbList {
                let timeStamp = trainingDb[self.timeStamp]
                let currentDistance = trainingDb[self.currentDistance]
                let userId = trainingDb[self.userId]
                let sessionId = trainingDb[self.sessionId]
                let trainingType = trainingDb[self.trainingType]
                let trainingEnvironmentType = trainingDb[self.trainingEnvironmentType]
                let dataType = trainingDb[self.dataType]
                let dataValue = trainingDb[self.dataValue]
                
                let training = Training(
                    timeStamp: timeStamp,
                    currentDistance: currentDistance,
                    userId: userId,
                    sessionId: sessionId,
                    trainingType: TrainingType(rawValue: trainingType) == nil ? TrainingType.kayak : TrainingType(rawValue: trainingType)!,
                    trainingEnvironmentType: TrainingEnvironmentType(rawValue: trainingEnvironmentType)!,
                    dataType: dataType,
                    dataValue: dataValue)
                
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
    override func loadUploadAbleData(pointer: Double) -> [Training]? {
        let predicate = self.timeStamp > pointer
        return loadData(predicate: predicate)
    }
    
    func loadUploadAbleData(sessionId: Double, timestampPointer: Double) -> [Training]? {
        let predicateTimestamp = self.timeStamp > timestampPointer
        let predicateSessionId = self.sessionId == sessionId
        return loadData(predicate: getSumPredicate(predicates: predicateTimestamp, predicateSessionId))
    }
    
    func getTrainingsByTypePredicate(sessionId: Double, type: CalculateEnum) -> Expression<Bool> {
        return self.sessionId == sessionId && self.dataType == type.rawValue
    }
    
    func getTrainingsBetweenSessionIdPredicate(sessionIdFrom: Double, sessionIdTo: Double) -> Expression<Bool> {
        return self.timeStamp >= sessionIdFrom && self.timeStamp <= sessionIdTo
    }
    
    func getPredicateSessionId(sessionId: Double) -> Expression<Bool> {
        return self.sessionId == sessionId
    }
}
