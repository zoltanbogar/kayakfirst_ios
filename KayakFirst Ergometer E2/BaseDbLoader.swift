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
    
    //MARK: properties
    let db = AppSql.sharedInstance.db
    
    //MARK: init
    init() {
        initDatabase()
    }
    
    //MARK: abstract functions
    func initDatabase() {
        fatalError("Must be implemented")
    }
    func addData(data: Input) {
        fatalError("Must be implemented")
    }
}
