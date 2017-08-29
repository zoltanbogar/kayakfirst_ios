//
//  JoinPlanPlanElements.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

struct PlanPlanElements {
    let planId: String
    let planElementId: String
}

class JoinPlanPlanElements: BaseDbLoader<PlanPlanElements> {
    
    //MARK: constants
    static let tableName = "plan_plan_elements"
    
    //MARK: init
    static let sharedInstance = JoinPlanPlanElements()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let planIdKey = "plan_id"
        static let planElementIdKey = "plan_element_id"
    }
    
    //MARK: columns
    let planIdValue = Expression<String>(PropertyKey.planIdKey)
    let planElementId = Expression<String>(PropertyKey.planElementIdKey)
    
    override func getTableName() -> String {
        return JoinPlanPlanElements.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        let tablePlan = Table(PlanDbLoader.tableName)
        let tablePlanElement = Table(PlanElementDbLoader.tableName)
        let planId = self.planId
        let planElementId = Expression<String>(PlanElementDbLoader.planElementIdKey)
        
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(self.planId)
            t.column(self.planElementId)
            t.foreignKey(self.planId, references: tablePlan, planIdValue)
            t.foreignKey(self.planElementId, references: tablePlanElement, planElementId)
        })
    }
    
    //MARK: insert
    override func addData(data: PlanPlanElements?) {
        if let planPlanElements = data {
            let insert = table?.insert(self.planId <- planPlanElements.planId, self.planElementId <- planPlanElements.planElementId)
            
            do {
                let rowId = try db?.run(insert!)
            } catch {
                log(databaseLogTag, error)
            }
        }
    }
    
    //MARK: delete
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
    
    func deleteAllWithoutPlanTraining() -> Int {
        let expression = !self.planElementId.like("%\(PlanTraining.planTrainingName)%")
        return deleteData(predicate: expression)
    }
}
