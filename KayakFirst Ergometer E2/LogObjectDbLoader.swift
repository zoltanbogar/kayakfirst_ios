//
//  LogObjectDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 24..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class LogObjectDbLoader: BaseDbLoader<LogObject> {
    
    //MARK: constants
    static let tableName = "log_object_table"
    
    //MARK: init
    static let sharedInstance = LogObjectDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let logKey = "log"
        static let systemInfoTimestampKey = "systemInfoTimestamp"
    }
    
    //MARK: columns
    private let logColumn = Expression<String>(PropertyKey.logKey)
    private let systemInfoTimestamp = Expression<Double>(PropertyKey.systemInfoTimestampKey)
    
    override func getTableName() -> String {
        return LogObjectDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(baseId, primaryKey: .autoincrement)
            t.column(logColumn)
            t.column(timestamp)
            t.column(systemInfoTimestamp)
            t.column(userId)
        })
    }
    
    //MARK: insert
    override func addData(data: LogObject?) {
        if let logObject = data {
            let insert = table!.insert(self.logColumn <- logObject.log, self.timestamp <- Double(Int64(logObject.timestamp)), self.systemInfoTimestamp <- Double(Int64(logObject.systemInfoTimestamp)), self.userId <- logObject.userId)
            
            let rowId = try? db?.run(insert)
        }
    }
    
    //MARK: query
    func getLogObjects(systemInfoTimestamp: Double) -> [LogObject]? {
        return loadData(predicate: self.systemInfoTimestamp == systemInfoTimestamp)
    }
    
    override func loadData(predicate: Expression<Bool>?) -> [LogObject]? {
        var logList: [LogObject]?
        
        let user = UserManager.sharedInstance.getUser()
        var userId: Int64 = 0
        
        if let user = user {
            userId = user.id
        }
        
        do {
            var queryPredicate = self.userId == userId
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            log("DB_TEST", "\(queryPredicate)")
            
            let dbList = try db!.prepare(table!.filter(queryPredicate))
            
            logList = [LogObject]()
            
            for logObjectDb in dbList {
                
                let logObject = LogObject(
                    row: logObjectDb,
                    logExpression: logColumn,
                    timestampExpression: timestamp,
                    systemInfoTimestampExpression: systemInfoTimestamp,
                    userIdExpression: self.userId)
                
                logList?.append(logObject)
                
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return logList
    }
    
    //MARK: update
    override func updateData(data: LogObject) {
        //nothing here
    }
    
    //MARK: delete
    func deleteOldData() {
        let predicate = self.timestamp < getOldDataTimestamp(oldDataDays: oldDataLogDays)
        deleteData(predicate: predicate)
    }
    
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
