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
    
    //MARK: properties
    let planElementDbLoader = PlanElementDbLoader.sharedInstance
    let joinPlanElementDbLoader = JoinPlanPlanElements.sharedInstance
    
    //MARK: init
    static let sharedInstance = PlanDbLoader()
    private override init() {
        super.init()
    }
    
    //MARK: keys
    struct PropertyKey {
        static let notesKey = "notes"
        static let lengthKey = "length"
    }
    
    //MARK: columns
    private let notes = Expression<String?>(PropertyKey.notesKey)
    private let length = Expression<Double>(PropertyKey.lengthKey)
    
    override func getTableName() -> String {
        return PlanDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(planId, primaryKey: true)
            t.column(userId)
            t.column(planType)
            t.column(name)
            t.column(notes)
            t.column(length)
        })
    }
    
    //MARK: insert
    func addPlanList(planList: [Plan]?) {
        if let planListValue = planList {
            do {
                try db!.transaction {
                    for plan in planListValue {
                        self.addData(data: plan)
                    }
                }
            } catch {
                log(databaseLogTag, error)
            }
        }
    }
    
    override func addData(data: Plan?) {
        if let plan = data {
            let insert = table!.insert(self.planId <- plan.planId, self.userId <- plan.userId, self.planType <- plan.type.rawValue, self.name <- plan.name ?? "", self.notes <- plan.notes, self.length <- plan.length)
            
            let rowId = try? db?.run(insert)
            
            addPlanWithChildren(plan: plan)
        }
    }
    
    private func addPlanWithChildren(plan: Plan) {
        if let planElements = plan.planElements {
            for i in 0..<planElements.count {
                var planElement = planElements[i]
                planElement.position = i
                planElementDbLoader.addData(data: planElement)
                joinPlanElementDbLoader.addData(data: PlanPlanElements(planId: plan.planId, planElementId: planElement.planElementId))
            }
        }
    }
    
    //MARK: query
    override func queryData(predicate: Expression<Bool>?) -> [Plan]? {
        var planList: [Plan]?
        
        do {
            let dbList = try db!.prepare(table!.filter(predicate!))
            
            planList = [Plan]()
            
            for planDb in dbList {
                let id = planDb[self.planId]
                let userId = planDb[self.userId]
                let type = PlanType(rawValue: planDb[self.planType])
                let name = planDb[self.name]
                let notes = planDb[self.notes]
                let length = planDb[self.length]
                let planElements: [PlanElement]?  = try! getPlanElementList(planId: id)
                
                let plan = Plan(
                 planId: id,
                 userId: userId,
                 type: type!,
                 name: name,
                 notes: notes,
                 length: length)
                plan.planElements = planElements
                 
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
                    planElementId: planElementDb[planElementDbLoader.id],
                    position: planElementDb[planElementDbLoader.position],
                    intensity: planElementDb[planElementDbLoader.intensity],
                    type: PlanType(rawValue: planElementDb[planElementDbLoader.planType])!,
                    value: planElementDb[planElementDbLoader.value]))
        }
        
        return planElementList
    }
    
    func getIdPredicate(planId: String) -> Expression<Bool> {
        return self.planId == planId
    }
    
    func getNamePredicate(name: String) -> Expression<Bool> {
        return self.name.like("%\(name)%")
    }
    
    //MARK: update
    override func updateData(data: Plan) {
        //nothing here
    }
    
    //MARK: delete
    override func deleteData(predicate: Expression<Bool>?) -> Int {
        let planList = loadData(predicate: predicate)
        
        var deletedRows = 0
        
        if planList != nil {
            for plan in planList! {
                deletedRows += deletePlan(plan: plan)
            }
        }
        
        return deletedRows
    }
    
    func deletePlan(plan: Plan) -> Int {
        let deleteData = table!.filter(self.planId == plan.planId)
        
        var deletedRows = 0
        
        do {
            deletedRows = try db!.run(deleteData.delete())
        } catch {
            log(databaseLogTag, error)
        }
        
        joinPlanElementDbLoader.deleteData(predicate: joinPlanElementDbLoader.planId == plan.planId)
        
        if let planElements = plan.planElements {
            planElementDbLoader.deleteData(predicate: planElementDbLoader.getExpressionDelete(planId: plan.planId))
        }
        return deletedRows
    }
}
