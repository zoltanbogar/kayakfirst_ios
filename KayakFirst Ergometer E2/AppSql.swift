//
//  AppSql.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class AppSql {
    
    //MARK: constants
    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    private let DB_VERSION = 1
    
    var db: Connection?
    
    //MARK: init
    static let sharedInstance = AppSql()
    private init() {
        initDatabase()
    }
    
    private func initDatabase() {
        do {
            db = try Connection("\(path)/db.sqlite3")
            
            if db!.userVersion == 0 {
                migrationForVersion1()
                db?.userVersion = DB_VERSION
            }
        } catch {
            log("DATABASE", error)
        }
    }
    
    private func migrationForVersion1() {
        dropTableIfExists(tableName: TrainingAvgDbLoader.tableName)
        dropTableIfExists(tableName: TrainingDbLoader.tableName)
        dropTableIfExists(tableName: SumTrainingDbLoader.tableName)
    }
    
    private func dropTableIfExists(tableName: String) {
        do {
            try db?.run(Table(tableName).drop(ifExists: true))
        } catch {
            log("DATABASE", error)
        }
    }
}
