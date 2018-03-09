//
//  SumTrainingDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class SumTrainingDbLoader: UploadAbleDbLoader<SumTraining, Double> {
    
    //MARK: constants
    static let tableName = "training_sum_table"
    
    //MARK: properties
    private var sessionIdValue: Double = 0
    
    //MARK: init
    static let sharedInstance = SumTrainingDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let artOfPaddleKey = "artOfPaddle"
        static let trainingEnvironmentTypeKey = "trainingEnvironmentType"
        static let trainingCountKey = "trainingCount"
        static let startTimeKey = "startTime"
        static let durationKey = "duration"
        static let distanceKey = "distance"
    }
    
    //MARK: columns
    private let artOfPaddle = Expression<String>(PropertyKey.artOfPaddleKey)
    private let trainingEnvironmentType = Expression<String>(PropertyKey.trainingEnvironmentTypeKey)
    private let trainingCount = Expression<Int>(PropertyKey.trainingCountKey)
    private let startTime = Expression<Double>(PropertyKey.startTimeKey)
    private let duration = Expression<Double>(PropertyKey.durationKey)
    
    override func getTableName() -> String {
        return SumTrainingDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(baseId, primaryKey: .autoincrement)
            t.column(sessionId)
            t.column(userId)
            t.column(artOfPaddle)
            t.column(trainingEnvironmentType)
            t.column(trainingCount)
            t.column(planTrainingId)
            t.column(planType)
            t.column(startTime)
            t.column(duration)
            t.column(distance)
        })
    }
    
    //MARK: insert
    func addSumTrainings(sumTrainings: [SumTraining]) {
        do {
            try db!.transaction {
                for sumTraining in sumTrainings {
                    self.addData(data: sumTraining)
                }
            }
        } catch {
            log(databaseLogTag, error)
        }
    }
    
    override func addData(data: SumTraining?) {
        if let sumTraining = data {
            if sessionIdValue != sumTraining.sessionId {
                sessionIdValue = sumTraining.sessionId
                
                let planType = sumTraining.planTrainingType != nil ? sumTraining.planTrainingType!.rawValue : ""
                
                let insert = table!.insert(self.sessionId <- Double(Int64(sumTraining.sessionId)), self.userId <- sumTraining.userId, self.artOfPaddle <- sumTraining.artOfPaddle, self.trainingEnvironmentType <- sumTraining.trainingEnvironmentType, self.trainingCount <- sumTraining.trainingCount, self.planTrainingId <- sumTraining.planTrainingId, self.planType <- planType, self.startTime <- sumTraining.startTime, self.duration <- sumTraining.duration, self.distance <- sumTraining.distance)
                
                let rowId = try? db?.run(insert)
            } else {
                updateData(data: sumTraining)
            }
        }
    }
    
    //MARK: update
    override func updateData(data: SumTraining) {
        let sum = table!.filter(self.sessionId == Double(Int64(data.sessionId)))
        do {
            try db!.run(sum.update(self.trainingCount <- data.trainingCount, self.duration <- data.duration, self.distance <- data.distance))
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
    
    func deleteDataBySessionId(sessionId: Double) {
        var sessionIds = [Double]()
        sessionIds.append(sessionId)
        deleteDataBySessionIds(sessionIds: sessionIds)
    }
    
    //TODO: test it
    func deleteDataBySessionIds(sessionIds: [Double]) {
        let predicate = getSumPredicateOr(column: self.sessionId, values: sessionIds)
        
        if let predicate = predicate {
            deleteData(predicate: predicate)
            TrainingAvgDbLoader.sharedInstance.deleteData(predicate: predicate)
            TrainingDbLoader.sharedInstance.deleteData(predicate: predicate)
            PlanTrainingDbLoader.sharedInstance.deleteData(predicate: predicate)
        }
    }
    
    func deleteOldData() {
        let predicate = getDeleteOldDataPredicate()
        
        deleteData(predicate: predicate)
        TrainingAvgDbLoader.sharedInstance.deleteData(predicate: predicate)
        TrainingDbLoader.sharedInstance.deleteData(predicate: predicate)
        PlanTrainingDbLoader.sharedInstance.deleteData(predicate: predicate)
    }
    
    //MARK: query
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
    
    func getSumTrainingsBySessionId(sessionIds: [Double]?) -> [SumTraining]? {
        if let sessionIds = sessionIds {
            return loadData(predicate: getSumPredicateOr(column: self.sessionId, values: sessionIds))
        }
        return nil
    }
    
    func getSumTrainingBySessionId(sessionId: Double) -> SumTraining? {
        let sumTrainings = loadData(predicate: getPredicateSessionId(sessionId: sessionId))
        
        if sumTrainings != nil && sumTrainings!.count > 0 {
            return sumTrainings?[0]
        }
        return nil
    }
    
    override func queryData(predicate: Expression<Bool>?) -> [SumTraining]? {
        return loadData(predicate: predicate)
    }
    
    override func loadData(predicate: Expression<Bool>?) -> [SumTraining]? {
        var sumTrainingList: [SumTraining]?
        
        do {
            var queryPredicate = self.userId == UserManager.sharedInstance.getUserId()
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            let dbList = try db!.prepare(table!.filter(queryPredicate).order(self.sessionId))
            
            sumTrainingList = [SumTraining]()
            
            for sumTrainingDb in dbList {
                let sessionId = sumTrainingDb[self.sessionId]
                let userId = sumTrainingDb[self.userId]
                let artOfPaddle = sumTrainingDb[self.artOfPaddle]
                let trainingEnvironmentType = sumTrainingDb[self.trainingEnvironmentType]
                let trainingCount = sumTrainingDb[self.trainingCount]
                let planTrainingId = sumTrainingDb[self.planTrainingId]
                let planType = PlanType(rawValue: sumTrainingDb[self.planType])
                let startTime = sumTrainingDb[self.startTime]
                let duration = sumTrainingDb[self.duration]
                let distance = sumTrainingDb[self.distance]
                
                let sumTraining = SumTraining(
                    sessionId: sessionId,
                    userId: userId,
                    artOfPaddle: artOfPaddle,
                    trainingEnvironmentType: trainingEnvironmentType,
                    trainingCount: trainingCount,
                    planTrainingId: planTrainingId,
                    planTrainingType: planType ?? nil,
                    startTime: startTime,
                    duration: duration,
                    distance: distance)
                
                sumTrainingList?.append(sumTraining)
                
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return sumTrainingList
    }
    
    override func loadUploadAbleData(pointer: Double) -> [SumTraining]? {
        //TODO
        return nil
    }
    
    func loadUploadAbleData(sessionIds: [Double]?) -> [SumTraining]? {
        if let sessionIds = sessionIds {
            return loadData(predicate: getSumPredicateOr(column: self.sessionId, values: sessionIds))
        }
        return nil
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
