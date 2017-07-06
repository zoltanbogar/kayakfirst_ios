//
//  PlanElementDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class PlanElementDbLoader: BaseDbLoader<PlanElement> {
    
    //MARK: constants
    static let tableName = "plan_element_table"
    static let planElementIdKey = "planElementId"
    
    //MARK: init
    static let sharedInstance = PlanElementDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let positionKey = "position"
        static let intensityKey = "intensity"
        static let valueKey = "value"
    }
    
    //MARK: columns
    let id = Expression<String>(PlanElementDbLoader.planElementIdKey)
    let position = Expression<Int>(PropertyKey.positionKey)
    let intensity = Expression<Int>(PropertyKey.intensityKey)
    let value = Expression<Double>(PropertyKey.valueKey)
    
    override func getTableName() -> String {
        return PlanElementDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(planType)
            t.column(position)
            t.column(intensity)
            t.column(value)
        })
    }
    
    //MARK: insert
    override func addData(data: PlanElement?) {
        if let planElement = data {
            let insert = table!.insert(self.id <- planElement.planElementId, self.position <- planElement.position, self.intensity <- planElement.intensity, self.planType <- planElement.type.rawValue, self.value <- planElement.value)
            
            let rowId = try? db?.run(insert)
        }
    }
    
    //MARK: update
    override func updateData(data: PlanElement) {
        //TODO
    }
    
    //MARK: query
    override func loadData(predicate: Expression<Bool>?) -> [PlanElement]? {
        var planElementList: [PlanElement]?
        
        do {
            let dbList: AnySequence<Row>?
            
            if predicate != nil {
                dbList = try db!.prepare(table!.filter(predicate!))
            } else {
                dbList = try db!.prepare(table!)
            }
            
            planElementList = [PlanElement]()
            
            if let dbListValue = dbList {
                for planElementDb in dbListValue {
                    let id = planElementDb[self.id]
                    let type = PlanType(rawValue: planElementDb[self.planType])
                    let position = planElementDb[self.position]
                    let intesity = planElementDb[self.intensity]
                    let value = planElementDb[self.value]
                    
                    let planElement = PlanElement(
                        planElementId: id,
                        position: position,
                        intensity: intesity,
                        type: type!,
                        value: value)
                    
                    planElementList!.append(planElement)
                }
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return planElementList
    }
    
    func getExpressionDelete(planId: String) -> Expression<Bool> {
        return self.id.like(planId)
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
}
