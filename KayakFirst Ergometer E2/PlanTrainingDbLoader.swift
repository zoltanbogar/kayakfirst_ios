//
//  PlanTrainingDbLoader.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 03..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

//TODO - DB: refactor this class (it is a copy of PlanDbLoader)
class PlanTrainingDbLoader: BaseDbLoader<PlanTraining> {
    
    //MARK: constants
    static let tableName = "plan_training_table"
    
    //MARK: properties
    let planElementDbLoader = PlanElementDbLoader.sharedInstance
    let joinPlanElementDbLoader = JoinPlanPlanElements.sharedInstance
    
    //MARK: init
    static let sharedInstance = PlanTrainingDbLoader()
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
        return PlanTrainingDbLoader.tableName
    }
    
    //MARK: init database
    override func initDatabase(database: Connection) throws {
        try database.run(table!.create(ifNotExists: true) { t in
            t.column(planTrainingId, primaryKey: true)
            t.column(userId)
            t.column(planType)
            t.column(name)
            t.column(notes)
            t.column(length)
            t.column(sessionId)
        })
    }
    
    //MARK: insert
    func addPlanTrainings(planTrainings: [PlanTraining]) {
        do {
            try db!.transaction {
                for planTraining in planTrainings {
                    self.addData(data: planTraining)
                }
            }
        } catch {
            log(databaseLogTag, error)
        }
    }
    
    override func addData(data: PlanTraining?) {
        if let planTraining = data {
            let insert = table!.insert(self.planTrainingId <- planTraining.planId, self.userId <- planTraining.userId, self.planType <- planTraining.type.rawValue, self.name <- planTraining.name ?? "", self.notes <- planTraining.notes, self.length <- planTraining.length, self.sessionId <- Double(Int64(planTraining.sessionId)))
            
            let rowId = try? db?.run(insert)
            
            addPlanWithChildren(planTraining: planTraining)
        }
    }
    
    private func addPlanWithChildren(planTraining: PlanTraining) {
        if let planElements = planTraining.planElements {
            for planElement in planElements {
                
                log("PLAN_ELEMENT", "id: \(planElement.planElementId)")
                
                planElementDbLoader.addData(data: planElement)
                joinPlanElementDbLoader.addData(data: PlanPlanElements(planId: planTraining.planId, planElementId: planElement.planElementId))
            }
        }
    }
    
    //MARK: query
    func getPlanTrainingBySessionId(sessionId: Double) -> PlanTraining? {
        let planTrainings = loadData(predicate: getPredicateSessionId(sessionId: sessionId))
        
        if planTrainings != nil && planTrainings!.count > 0 {
            return planTrainings?[0]
        }
        return nil
    }
    
    override func queryData(predicate: Expression<Bool>?) -> [PlanTraining]? {
        var planList: [PlanTraining]?
        
        do {
            let dbList = try db!.prepare(table!.filter(predicate!))
            
            planList = [PlanTraining]()
            
            for planDb in dbList {
                let id = planDb[self.planTrainingId]
                let userId = planDb[self.userId]
                let type = PlanType(rawValue: planDb[self.planType])
                let name = planDb[self.name]
                let notes = planDb[self.notes]
                let length = planDb[self.length]
                let planElements: [PlanElement]?  = try! getPlanElementList(planId: id)
                let sessionId = planDb[self.sessionId]
                
                let planTraining = PlanTraining(
                    planId: id,
                    userId: userId,
                    planType: type!,
                    name: name,
                    notes: notes,
                    length: length,
                    sessionId: sessionId)
                planTraining.planElements = planElements
                
                planList!.append(planTraining)
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
    
    func getExpressionSessionId(sessionIdFrom: Double, sessionIdTo: Double) -> Expression<Bool>? {
        return getSumPredicate(predicates: self.sessionId > sessionIdFrom, self.sessionId <= sessionIdTo)
    }
    
    func getExpressionById(planTrainingId: String) -> Expression<Bool> {
        return self.planTrainingId == planTrainingId
    }
    
    func getExpressionBySessionId(sessionId: Double) -> Expression<Bool> {
        return self.sessionId == sessionId
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
    
    func deletePlan(plan: PlanTraining) -> Int {
        let deleteData = table!.filter(self.planTrainingId == plan.planId)
        
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
    
    private func getPredicateSessionId(sessionId: Double) -> Expression<Bool> {
        return self.sessionId == sessionId
    }
}
