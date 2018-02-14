//
//  Plan.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PlanType: String {
    case time = "time"
    case distance = "distance"
}

class Plan: PlanObject, ModifyAble {
    
    //MARK: constants
    private let planName = "plan"
    
    //MARK: properties
    var planId: String = ""
    var userId: Int64 = 0
    var type: PlanType
    var name: String?
    var notes: String?
    var length: Double = 0
    var planElements: [PlanElement]? {
        didSet {
            length = calculatePlanLength()
        }
    }
    
    //MARK: init
    init(type: PlanType) {
        self.type = type
        
        userId = UserManager.sharedInstance.getUserId()
        planId = Plan.createPlanId(name: getPlanObjectName(), createValue: "\(userId)")
    }
    
    init(planId: String, userId: Int64, type: PlanType, name: String?, notes: String?, length: Double) {
        self.planId = planId
        self.name = name
        self.notes = notes
        self.userId = userId
        self.length = length
        self.type = type
    }
    
    init?(json: JSON) {
        self.planId = json["planId"].stringValue
        self.name = json["name"].stringValue
        self.notes = json["notes"].stringValue
        self.userId = json["userId"].int64Value
        self.length = json["length"].doubleValue
        
        if PlanType(rawValue: json["type"].stringValue) == nil {
            return nil
        } else {
            self.type = PlanType(rawValue: json["type"].stringValue)!
            
            var planElements = [PlanElement]()
            
            for planElementDto in json["planElements"].arrayValue {
                let planElement = PlanElement(
                    planElementId: planElementDto["planElementId"].stringValue,
                    position: planElementDto["position"].intValue,
                    intensity: planElementDto["intensity"].intValue,
                    type: PlanType(rawValue: planElementDto["type"].stringValue)!,
                    value: planElementDto["value"].doubleValue)
                
                planElements.append(planElement)
            }
            self.planElements = planElements
        }
    }
    
    //MARK: functions
    func getFormattedDuration() -> String {
        return Plan.getFormattedValue(planType: type, value: length)
    }
    
    private func calculatePlanLength() -> Double {
        var sum: Double = 0
        if let planElementList = planElements {
            for planElement in planElementList {
                sum += planElement.value
            }
        }
        return sum
    }
    
    //MARK: protocol
    func getPlanObjectName() -> String {
        return planName
    }
    
    func getUploadPointer() -> String {
        return planId
    }
    
    func getParameters() -> [String : Any] {
        var planElementParameters: [String : Any]?
        
        var planElementList: Array<[String:Any]> = []
        
        if planElements != nil && planElements!.count > 0 {
            planElementParameters = [String : Any]()
            
            for planElement in planElements! {
                planElementParameters = planElement.getParameters()
                planElementList.append(planElementParameters!)
            }
        }
        
        return [
            "planId": planId,
            "userId": userId,
            "type": type.rawValue,
            "name": name ?? "",
            "notes": notes ?? "",
            "length": length,
            "planElements": planElementList ?? ""
        ]
    }
    
    //MARK: static functions
    static func getFormattedValue(planType: PlanType, value: Double) -> String {
        switch planType {
        case PlanType.distance:
            let formattedValue = String.init(format: "%.0f", UnitHelper.getDistanceValue(metricValue: value))
            let unit = UnitHelper.getDistanceUnit()
            
            return "\(formattedValue) \(unit)"
        case PlanType.time:
            return DateFormatHelper.getDate(dateFormat: DateFormatHelper.minSecFormat, timeIntervallSince1970: Double(value))
        }
    }
    
    static func createCopy(plan: Plan) -> Plan {
        let newPlan = Plan(
            planId: plan.planId,
            userId: plan.userId,
            type: plan.type,
            name: plan.name,
            notes: plan.notes,
            length: plan.length)
        newPlan.planElements = plan.planElements
        return newPlan
    }
    
    static func createPlanId(name: String, createValue: String) -> String {
        return "\(name)_\(Int64(currentTimeMillis()))_\(createValue)"
    }
}
