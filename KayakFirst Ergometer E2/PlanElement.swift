//
//  PlanElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

struct PlanElement {
    
    //MARK: properties
    var id: String
    var planId: String
    var type: PlanType
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
    var value: Int64 = 0
    
    //MARK: helper properties
    private var _intensity: Int = 0
    
    //MARK: init
    init(planId: String, type: PlanType) {
        self.planId = planId
        self.type = type
        
        id = Plan.createPlanId(createValue: planId)
    }
    
    init(planId: String, intensity: Int, type: PlanType, value: Int64) {
        self.planId = planId
        self._intensity = intensity
        self.type = type
        self.value = value
        
        id = Plan.createPlanId(createValue: planId)
    }
    
    init(id: String, planId: String, intensity: Int, type: PlanType, value: Int64) {
        self.id = id;
        self.planId = planId
        self._intensity = intensity
        self.type = type
        self.value = value
    }
    
    //MARK: functions
    func getFormattedValue() -> String {
        switch type {
        case PlanType.distance:
            return "\(value)"
        case PlanType.time:
            return DateFormatHelper.getDate(dateFormat: DateFormatHelper.minSecFormat, timeIntervallSince1970: Double(value))
        default:
            fatalError("there is no other type")
        }
    }
}
