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
    
    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    var db: Connection?
    
    //MARK: init
    static let sharedInstance = AppSql()
    private init() {
        initDatabase()
    }
    
    private func initDatabase() {
        do {
            db = try Connection("\(path)/db.sqlite3")
        } catch {
            log("DATABASE", error)
        }
    }
    
}
