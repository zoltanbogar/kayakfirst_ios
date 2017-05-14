//
//  Plan.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum PlanType: String {
    case time = "time"
    case distance = "distance"
}

class Plan {
    
    //MARK: properties
    var planId: String
    var userId: Int64
    var type: PlanType
    var name: String?
    var notes: String?
    var timestamp: TimeInterval?
    var length: Int64 = 0
    var sessionId: TimeInterval?
    var planElements: [PlanElement]? {
        didSet {
            length = calculatePlanLength()
        }
    }
    
    //MARK: init
    init(type: PlanType) {
        self.type = type
        
        userId = UserService.sharedInstance.getUser()!.id
        planId = Plan.createPlanId(createValue: "\(userId)")
    }
    
    init(planId: String, name: String?, notes: String?, timestamp: TimeInterval?, userId: Int64, length: Int64, type: PlanType, sessionId: TimeInterval?) {
        self.planId = planId
        self.name = name
        self.notes = notes
        self.timestamp = timestamp
        self.userId = userId
        self.length = length
        self.type = type
        self.sessionId = sessionId
    }
    
    //MARK: functions
    private func calculatePlanLength() -> Int64 {
        var sum: Int64 = 0
        if let planElementList = planElements {
            for planElement in planElementList {
                sum += planElement.value
            }
        }
        return sum
    }
    
    
    //MARK: static functions
    static func createPlanId(createValue: String) -> String {
        return "\(Int64(currentTimeMillis()))_\(createValue)"
    }
    
    //TODO: delete this
    public static func getExamplePlans() -> [Plan] {
        var plans = [Plan]()
        
        for i in 0...15 {
            var type = PlanType.distance
            
            if i % 2 == 0 {
                type = PlanType.time
            }
            
            var plan = Plan(type: type)
            plan.name = "Nametest\(i)"
            plan.notes = "Notestest\(i)"
            
            var planElements = [PlanElement]()
            for i in 0...10 {
                let planElement = PlanElement(
                    planId: plan.planId,
                    intensity: i * 10,
                    type: plan.type,
                    value: Int64(i * 10000))
                
                planElements.append(planElement)
            }
            
            plan.planElements = planElements
            
            plans.append(plan)
        }
        return plans
    }
    
}
