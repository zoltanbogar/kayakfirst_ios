//
//  PlanElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

struct PlanElement: PlanObject, UploadAble {
    typealias E = String
    
    //MARK: constants
    private let planElementName = "plan_element"
    
    //MARK: properties
    var planElementId: String = ""
    var type: PlanType
    var position: Int = 0
    var intensity: Int {
        get {
            return _intensity
        }
        set {
            if newValue >= 0 && newValue <= 100 {
                _intensity = newValue
            } else {
                _intensity = 100
            }
        }
    }
    var value: Double = 0
    
    //MARK: helper properties
    private var _intensity: Int = 0
    
    //MARK: init
    init(planId: String, type: PlanType) {
        self.type = type
        
        planElementId = Plan.createPlanId(name: getPlanObjectName(), createValue: planId)
    }
    
    init(planId: String, intensity: Int, type: PlanType, value: Double) {
        self.type = type
        self.value = value
        
        planElementId = Plan.createPlanId(name: getPlanObjectName(), createValue: planId)
        
        self._intensity = intensity
    }
    
    init(planElementId: String, position: Int, intensity: Int, type: PlanType, value: Double) {
        self.planElementId = planElementId
        self.position = position
        self._intensity = intensity
        self.type = type
        self.value = value
    }
    
    //MARK: functions
    func getFormattedValue() -> String {
        return Plan.getFormattedValue(planType: type, value: value)
    }
    
    //MARK: protocol
    func getUploadPointer() -> String {
        return planElementId
    }
    
    func getPlanObjectName() -> String {
        return planElementName
    }
    
    func getParameters() -> [String : Any] {
        return [
            "planElementId": planElementId,
            "type": type.rawValue,
            "position": position,
            "intensity": intensity,
            "value": value
        ]
    }
    
    //MARK: static functions
    static func createNewPlanElement(planId: String, planElement: PlanElement) -> PlanElement {
        var newPlanElement = PlanElement(
            planId: planId,
            intensity: planElement.intensity,
            type: planElement.type,
            value: planElement.value)
        newPlanElement.position = planElement.position
        
        return newPlanElement
    }
}
