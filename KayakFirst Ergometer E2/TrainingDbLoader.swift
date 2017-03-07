//
//  TrainingDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingDbLoader: BaseDbLoader<Training> {
    
    //MARK: init
    override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let timeStampKey = "timeStamp"
        static let currentDistanceKey = "currentDistance"
        static let userIdKey = "userId"
        static let trainingTypeKey = "trainingType"
        static let trainingEnvironmentTypeKey = "trainingEnvironmentType"
        static let dataTypeKey = "dataType"
        static let dataValueKey = "dataValueKey"
    }
    
    //MARK: columns
    private let timeStamp = Expression<Double>(PropertyKey.timeStampKey)
    private let currentDistance = Expression<Double>(PropertyKey.currentDistanceKey)
    private let userId = Expression<Int64>(PropertyKey.userIdKey)
    private let trainingType = Expression<String>(PropertyKey.trainingTypeKey)
    private let trainingEnvironmentType = Expression<String>(PropertyKey.trainingEnvironmentTypeKey)
    private let dataType = Expression<String>(PropertyKey.dataTypeKey)
    private let dataValue = Expression<Double>(PropertyKey.dataValueKey)
    
    //MARK: init database
    override func initDatabase() {
        table = Table("training_table")
        do {
            if let database = db {
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
        } catch {
            log("DATABASE", error)
        }
    }
    
    //MARK: insert
    override func addData(data: Training) {
        let insert = table!.insert(self.timeStamp <- data.timeStamp, self.currentDistance <- data.currentDistance, self.userId <- data.userId!, self.sessionId <- data.sessionId, self.trainingType <- data.trainingType.rawValue, self.trainingEnvironmentType <- data.trainingEnvironmentType.rawValue, self.dataType <- data.dataType, self.dataValue <- data.dataValue)
        
        let rowId = try? db?.run(insert)
    }
    
    //MARK: query
    func getTrainingsBetweenSessionIdPredicate(sessionIdFrom: Double, sessionIdTo: Double) -> Expression<Bool> {
        return self.timeStamp > sessionIdFrom && self.timeStamp <= sessionIdTo
    }
    
    override func loadData(predicate: Expression<Bool>?) -> [Training]? {
        var trainingList: [Training]?
        
        do {
            var queryPredicate = self.userId == UserService.sharedInstance.getUser()!.id
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            let dbList = try db!.prepare(table!.filter(queryPredicate))
            
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
                    trainingType: TrainingType(rawValue: trainingType)!,
                    trainingEnvironmentType: TrainingEnvironmentType(rawValue: trainingEnvironmentType)!,
                    dataType: dataType,
                    dataValue: dataValue)
                
                trainingList?.append(training)
                
            }
        } catch {
            log("DATABASE", error)
        }
        
        return trainingList
    }
}
