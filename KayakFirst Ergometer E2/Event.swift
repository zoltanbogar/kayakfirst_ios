//
//  Event.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

struct Event: PlanObject, ModifyAble {
    
    //MARK: constants
    let defaultHour = 8
    let eventName = "event"
    
    //MARK: properties
    var eventId: String = ""
    var userId: Int64 = 0
    var sessionId: Double
    var timestamp: Double
    var name: String
    var planType: PlanType
    var planId: String
    
    //MARK: init
    init(userId: Int64, sessionId: Double, timestamp: Double, name: String, planType: PlanType, planId: String) {
        self.userId = userId
        self.sessionId = sessionId
        self.timestamp = timestamp
        self.name = name
        self.planType = planType
        self.planId = planId
        
        self.eventId = Plan.createPlanId(name: getPlanObjectName(), createValue: "\(userId)")
    }
    
    init(eventId: String, userId: Int64, sessionId: Double, timestamp: Double, name: String, planType: PlanType, planId: String) {
        self.eventId = eventId
        self.userId = userId
        self.sessionId = sessionId
        self.timestamp = timestamp
        self.name = name
        self.planType = planType
        self.planId = planId
    }
    
    //MARK: protocol
    func getPlanObjectName() -> String {
        return eventName
    }
    
    func getPointer() -> String {
        return eventId
    }
}
