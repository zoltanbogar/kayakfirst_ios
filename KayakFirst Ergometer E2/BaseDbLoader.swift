//
//  BaseDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class BaseDbLoader<Input> {
    
    //MARK: constants
    let databaseLogTag = "DATABASE"
    let oldDataDays: TimeInterval = 30
    
    //MARK: properties
    let db = AppSql.sharedInstance.db
    
    let sessionId = Expression<Double>("sessionId")
    let userId = Expression<Int64>("userId")
    let timestamp = Expression<Double>("timestamp")
    let baseId = Expression<Int>("id")
    
    //training
    let force = Expression<Double>("force")
    let speed = Expression<Double>("speed")
    let distance = Expression<Double>("distance")
    let strokes = Expression<Double>("strokes")
    let t200 = Expression<Double>("t200")
    
    //plan
    let planTrainingId = Expression<String> ("planTrainingId")
    let planType = Expression<String>("planType")
    let planId = Expression<String>("planId")
    let name = Expression<String>("name")
    
    var table: Table?
    
    //MARK: init
    init() {
        initBaseDatabase()
    }
    
    //MARK: functions
    private func initBaseDatabase() {
        table = Table(getTableName())
        do {
            if let database = db {
                try initDatabase(database: database)
            }
        } catch {
            log(databaseLogTag, error)
        }
    }
    
    func addDataList(dataList: [Input]?) {
        if let dataListValue = dataList {
            do {
                try db!.transaction {
                    for data in dataListValue {
                        self.addData(data: data)
                    }
                }
            } catch {
                log(databaseLogTag, error)
            }
        }
    }
    
    func loadData(predicate: Expression<Bool>?) -> [Input]? {
        return queryData(predicate: getSumPredicate(predicates: getUserQuery(), predicate))
    }
    
    func deleteUserData() -> Int {
        return deleteData(predicate: getUserQuery())
    }
    
    func deleteAll() -> Int {
        var deletedRows = 0
        
        do {
            deletedRows = try db!.run(table!.delete())
        } catch {
            log(databaseLogTag, error)
        }
        return deletedRows
    }
    
    func getUserQuery() -> Expression<Bool> {
        return self.userId == UserManager.sharedInstance.getUserId()
    }
    
    func getOldDataTimestamp(oldDataDays: TimeInterval) -> Double {
        let oldaDataDaysInMillis: TimeInterval = oldDataDays * 24 * 60 * 60 * 1000
        let timestamp = currentTimeMillis() - oldaDataDaysInMillis
        
        return timestamp
    }
    
    //MARK: functions
    func getSumPredicate(predicates: Expression<Bool>?...) -> Expression<Bool>? {
        var sumPredicate: Expression<Bool>? = nil
        for predicate in predicates {
            if let predicateValue = predicate {
                if sumPredicate == nil {
                    sumPredicate = predicateValue
                } else {
                    sumPredicate = sumPredicate! && predicateValue
                }
            }
        }
        return sumPredicate
    }
    
    //MARK: abstract functions
    func getTableName() -> String {
        fatalError("Must be implemented")
    }
    func initDatabase(database: Connection) throws {
        fatalError("Must be implemented")
    }
    func addData(data: Input?) {
        fatalError("Must be implemented")
    }
    func queryData(predicate: Expression<Bool>?) -> [Input]? {
        fatalError("Must be implemented")
    }
    func updateData(data: Input) {
        fatalError("Must be implemented")
    }
    func deleteData(predicate: Expression<Bool>?) -> Int {
        fatalError("Must be implemented")
    }
}
