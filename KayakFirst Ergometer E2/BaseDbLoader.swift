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
    var table: Table?
    
    //MARK: init
    init() {
        initBaseDatabase()
    }
    
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
    
    func deleteData(timeStampFrom: Double) {
        let oldData = table!.filter(self.sessionId < timeStampFrom)
        
        do {
            try db?.run(oldData.delete())
        } catch {
            log("DATABASE", error)
        }
    }
    
    //MARK: abstract functions
    func getTableName() -> String {
        fatalError("Must be implemented")
    }
    func initDatabase(database: Connection) throws {
        fatalError("Must be implemented")
    }
    func addData(data: Input) {
        fatalError("Must be implemented")
    }
    func loadData(predicate: Expression<Bool>?) -> [Input]? {
        fatalError("Must be implemented")
    }
    func updateData(data: Input) {
        fatalError("Must be implemented")
    }
}
