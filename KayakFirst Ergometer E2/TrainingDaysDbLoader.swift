//
//  TrainingDaysDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class TrainingDaysDbLoader: BaseDbLoader<Double> {
    
    //MARK: constants
    static let tableName = "training_days_table"
    
    //MARK: init
    static let sharedInstance = TrainingDaysDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: columns
    override func getTableName() -> String {
        return TrainingDaysDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(sessionId, primaryKey: true)
            t.column(userId)
        })
    }
    
    //MARK: insert
    override func addData(data: Double) {
        let insert = table!.insert(self.sessionId <- data, self.userId <- UserService.sharedInstance.getUser()!.id)
        
        let rowId = try? db?.run(insert)
    }
    
    //MARK: query
    override func loadData(predicate: Expression<Bool>?) -> [Double]? {
        var trainingDaysList: [Double]?
        
        do {
            var queryPredicate = self.userId == UserService.sharedInstance.getUser()!.id
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            let dbList = try db!.prepare(table!.filter(queryPredicate))
            
            trainingDaysList = [Double]()
            
            for trainingDaysDb in dbList {
                let sessionId = trainingDaysDb[self.sessionId]
                
                //it is for the calendarView
                trainingDaysList?.append(DateFormatHelper.getZeroHour(timeStamp: sessionId))
                
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return trainingDaysList
    }
}
