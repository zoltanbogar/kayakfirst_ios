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
        static let idKey = planElementIdKey
        static let planIdKey = "planId"
        static let typeKey = "type"
        static let intensityKey = "intensity"
        static let valueKey = "value"
    }
    
    //MARK: columns
    let id = Expression<String>(PropertyKey.idKey)
    let planId = Expression<String>(PropertyKey.planIdKey)
    let type = Expression<String>(PropertyKey.typeKey)
    let intensity = Expression<Int>(PropertyKey.intensityKey)
    let value = Expression<Int64>(PropertyKey.valueKey)
    
    override func getTableName() -> String {
        return PlanElementDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(planId)
            t.column(type)
            t.column(intensity)
            t.column(value)
        })
    }
    
    //MARK: insert
    override func addData(data: PlanElement) {
        let insert = table!.insert(self.id <- data.id, self.planId <- data.planId, self.type <- data.type.rawValue, self.intensity <- data.intensity, self.value <- data.value)
        
        let rowId = try? db?.run(insert)
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
                    let planId = planElementDb[self.planId]
                    let type = PlanType(rawValue: planElementDb[self.type])
                    let intesity = planElementDb[self.intensity]
                    let value = planElementDb[self.value]
                    
                    let planElement = PlanElement(
                        id: id,
                        planId: planId,
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
    
}
