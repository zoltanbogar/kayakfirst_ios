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
    let sessionId = Expression<Double>("sessionId")
    var table: Table?
    
    //MARK: init
    init() {
        initDatabase()
    }
    
    func deleteData(timeStampFrom: Double) {
        let oldData = table!.filter(self.sessionId < timeStampFrom)
        
        do {
            try db?.run(oldData.delete())
        } catch {
            print(error)
        }
    }
    
    func initDatabase() {
        fatalError("Must be implemented")
    }
    func addData(data: Input) {
        fatalError("Must be implemented")
    }
    func loadData(predicate: Expression<Bool>?) -> [Input]? {
        fatalError("Must be implemented")
    }
}
