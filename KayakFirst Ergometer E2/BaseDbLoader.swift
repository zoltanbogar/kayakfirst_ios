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
    
    //MARK: properties
    let db = AppSql.sharedInstance.db
    let sessionId = Expression<Double>("sessionId")
    let userId = Expression<Int64>("userId")
    let planType = Expression<String>("planType")
    let planId = Expression<String>("planId")
    let name = Expression<String>("name")
    let timestamp = Expression<Double>("timestamp")
    
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

    //TODO: is it sure?
    func deleteData(timeStampFrom: Double) {
        let oldData = table!.filter(self.sessionId < timeStampFrom)
        
        do {
            try db?.run(oldData.delete())
        } catch {
            log(databaseLogTag, error)
        }
    }
    
    func loadData(predicate: Expression<Bool>?) -> [Input]? {
        return queryData(predicate: getSumPredicate(predicates: getUserQuery(), predicate))
    }
    
    func getUserQuery() -> Expression<Bool> {
        return self.userId == UserManager.sharedInstance.getUser()!.id
    }
    
    //MARK: static functions
    func getSumPredicate(predicates: Expression<Bool>?...) -> Expression<Bool>? {
        var sumPredicate: Expression<Bool>? = predicates[0]
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
