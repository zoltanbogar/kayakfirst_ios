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
    var length: Double = 0
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
    
    init(planId: String, name: String?, notes: String?, timestamp: TimeInterval?, userId: Int64, length: Double, type: PlanType, sessionId: TimeInterval?) {
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
    private func calculatePlanLength() -> Double {
        var sum: Double = 0
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
    
    //MARK: functions
    static func getFormattedValue(planType: PlanType, value: Double) -> String {
        switch planType {
        case PlanType.distance:
            let formattedValue = String.init(format: "%.1f", UnitHelper.getDistanceValue(metricValue: value))
            let unit = UnitHelper.getDistanceUnit()
            
            return "\(formattedValue) \(unit)"
        case PlanType.time:
            return DateFormatHelper.getDate(dateFormat: DateFormatHelper.minSecFormat, timeIntervallSince1970: Double(value))
        default:
            fatalError("there is no other type")
        }
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
            plan.notes = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\(i)"
            
            var planElements = [PlanElement]()
            for i in 0...2 {
                let planElement = PlanElement(
                    planId: plan.planId,
                    intensity: i * 10,
                    type: plan.type,
                    value: Double(i * 10000))
                
                planElements.append(planElement)
            }
            
            planElements[0].value = 20
            planElements[1].value = 40
            planElements[2].value = 80
            
            planElements[0].intensity = 20
            planElements[1].intensity = 80
            planElements[2].intensity = 79
            
            plan.planElements = planElements
            
            plans.append(plan)
        }
        return plans
    }
    
}
