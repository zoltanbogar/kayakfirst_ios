//
//  SumTrainingDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class SumTrainingDbLoader: UploadAbleDbLoader<SumTrainingNew, Double> {
    
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
    override func addData(data: SumTrainingNew?) {
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
    override func updateData(data: SumTrainingNew) {
        let sum = table!.filter(self.sessionId == data.sessionId)
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
    
    func getSumTrainingBySessionId(sessionId: Double) -> SumTrainingNew? {
        let sumTrainings = loadData(predicate: getPredicateSessionId(sessionId: sessionId))
        
        if sumTrainings != nil && sumTrainings!.count > 0 {
            return sumTrainings?[0]
        }
        return nil
    }
    
    override func queryData(predicate: Expression<Bool>?) -> [SumTrainingNew]? {
        return loadData(predicate: predicate)
    }
    
    override func loadData(predicate: Expression<Bool>?) -> [SumTrainingNew]? {
        var sumTrainingList: [SumTrainingNew]?
        
        do {
            var queryPredicate = self.userId == UserManager.sharedInstance.getUserId()
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            let dbList = try db!.prepare(table!.filter(queryPredicate).order(self.sessionId))
            
            sumTrainingList = [SumTrainingNew]()
            
            for sumTrainingDb in dbList {
                let sessionId = sumTrainingDb[self.sessionId]
                let userId = sumTrainingDb[self.userId]
                let artOfPaddle = sumTrainingDb[self.artOfPaddle]
                let trainingEnvironmentType = sumTrainingDb[self.trainingEnvironmentType]
                let trainingCount = sumTrainingDb[self.trainingCount]
                let planTrainingId = sumTrainingDb[self.planTrainingId]
                let planType = sumTrainingDb[self.planType]
                let startTime = sumTrainingDb[self.startTime]
                let duration = sumTrainingDb[self.duration]
                let distance = sumTrainingDb[self.distance]
                
                let sumTraining = SumTrainingNew(
                    sessionId: sessionId,
                    userId: userId,
                    artOfPaddle: artOfPaddle,
                    trainingEnvironmentType: trainingEnvironmentType,
                    trainingCount: trainingCount,
                    planTrainingId: planTrainingId,
                    planTrainingType: PlanType(rawValue: planType)!,
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
    
    override func loadUploadAbleData(pointer: Double) -> [SumTrainingNew]? {
        //TODO
        return nil
    }
    
    override func getDeleteOldDataPredicate() -> Expression<Bool> {
        return self.sessionId < getOldDataTimestamp(oldDataDays: oldDataDays)
    }
    
    private func getPredicateSessionId(sessionId: Double) -> Expression<Bool> {
        return self.sessionId == sessionId
    }
    
}
