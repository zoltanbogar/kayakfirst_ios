//
//  PlanDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class PlanDbLoader: BaseDbLoader<Plan> {
    
    //MARK: constants
    static let tableName = "plan_table"
    static let planIdKey = "planId"
    
    //MARK: properties
    private let planElementDbLoader = PlanElementDbLoader.sharedInstance
    private let joinPlanElementDbLoader = JoinPlanPlanElements.sharedInstance
    
    //MARK: init
    static let sharedInstance = PlanDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let idKey = planIdKey
        static let userIdKey = "userIdKey"
        static let typeKey = "type"
        static let nameKey = "name"
        static let notesKey = "notes"
        static let timestampKey = "timestamp"
        static let lengthKey = "length"
        static let sessionIdKey = "sessionId"
    }
    
    //MARK: columns
    private let id = Expression<String>(PropertyKey.idKey)
    private let userId = Expression<Int64>(PropertyKey.userIdKey)
    private let type = Expression<String>(PropertyKey.typeKey)
    private let name = Expression<String?>(PropertyKey.nameKey)
    private let notes = Expression<String?>(PropertyKey.notesKey)
    private let timestamp = Expression<Double?>(PropertyKey.timestampKey)
    private let length = Expression<Int64>(PropertyKey.lengthKey)
    private let sessionIdPlan = Expression<Double?>(PropertyKey.sessionIdKey)
    
    override func getTableName() -> String {
        return PlanDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(userId)
            t.column(type)
            t.column(name)
            t.column(notes)
            t.column(timestamp)
            t.column(length)
            t.column(sessionIdPlan)
        })
    }
    
    //MARK: insert
    override func addData(data: Plan) {
        let insert = table!.insert(self.id <- data.planId, self.userId <- data.userId, self.type <- data.type.rawValue, self.name <- data.name, self.notes <- data.notes, self.timestamp <- data.timestamp, self.length <- data.length, self.sessionIdPlan <- data.sessionId)
        
        let rowId = try? db?.run(insert)
        
        addPlanWithChildren(plan: data)
    }
    
    private func addPlanWithChildren(plan: Plan) {
        if let planElements = plan.planElements {
            for planElement in planElements {
                planElementDbLoader.addData(data: planElement)
                joinPlanElementDbLoader.addData(data: PlanPlanElements(planId: plan.planId, planElementId: planElement.id))
            }
        }
    }
    
    //MARK: query
    override func loadData(predicate: Expression<Bool>?) -> [Plan]? {
        var planList: [Plan]?
        
        do {
            var queryPredicate = self.userId == UserService.sharedInstance.getUser()!.id
            
            if let predicateValue = predicate {
                queryPredicate = queryPredicate && predicateValue
            }
            
            let dbList = try db!.prepare(table!.filter(queryPredicate))
            
            planList = [Plan]()
            
            for planDb in dbList {
                let id = planDb[self.id]
                let userId = planDb[self.userId]
                let type = PlanType(rawValue: planDb[self.type])
                let name = planDb[self.name]
                let notes = planDb[self.notes]
                let timestamp = planDb[self.timestamp]
                let length = planDb[self.length]
                let sessionId = planDb[self.sessionIdPlan]
                
                let plan = Plan(
                    planId: id,
                    name: name,
                    notes: notes,
                    timestamp: timestamp,
                    userId: userId,
                    length: length,
                    type: type!,
                    sessionId: sessionId)
                
                planList!.append(plan)
            }
        } catch {
            log(databaseLogTag, error)
        }
        
        return planList
    }
    
    private func getPlanElementList(planId: String) throws -> [PlanElement]? {
        var planElementList = [PlanElement]()
        
        let query = planElementDbLoader.table?.join(joinPlanElementDbLoader.table!, on: joinPlanElementDbLoader.table![joinPlanElementDbLoader.planElementId] == planElementDbLoader.table![planElementDbLoader.id]).filter(joinPlanElementDbLoader.planId == planId)
        
        let dbList = try db!.prepare(query!)
        
        for planElementDb in dbList {
            planElementList.append(
                PlanElement(
                    id: planElementDb[planElementDbLoader.id],
                    planId: planElementDb[planElementDbLoader.planId],
                    intensity: planElementDb[planElementDbLoader.intensity],
                    type: PlanType(rawValue: planElementDb[planElementDbLoader.type])!,
                    value: planElementDb[planElementDbLoader.value]))
        }
        
        return planElementList
    }
    
    
    
}
