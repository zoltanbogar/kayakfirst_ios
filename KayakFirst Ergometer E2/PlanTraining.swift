//
//  PlanTraining.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SwiftyJSON

class PlanTraining: Plan {
    
    //MARK: constants
    private let planTrainingName = "plan_training"
    
    //MARK: static functions
    class func createPlanTraining(plan: Plan) -> PlanTraining {
        let planTraining = PlanTraining(planType: plan.type)
        planTraining.name = plan.name
        planTraining.notes = plan.notes
        planTraining.userId = plan.userId
        
        var planElements: [PlanElement]?
        
        if let elements = plan.planElements {
            planElements = [PlanElement]()
            
            for planElement in elements {
                planElements!.append(PlanElement.createNewPlanElement(planId: planTraining.planId, planElement: planElement))
                
                //createTimestamp won't be the same
                usleep(5000)
            }
        }
        
        planTraining.planElements = planElements
        
        return planTraining
    }
    
    //MARK: properties
    var sessionId: Double = 0
    
    //MARK: init
    init(planType: PlanType) {
        super.init(type: planType)
    }
    
    init(planId: String, userId: Int64, planType: PlanType, name: String?, notes: String?, length: Double, sessionId: Double) {
        super.init(planId: planId, userId: userId, type: planType, name: name, notes: notes, length: length)
        self.sessionId = sessionId
    }
    
    override init?(json: JSON) {
        super.init(json: json)
        self.sessionId = json["sessionId"].doubleValue
    }
    
    //MARK: protocol
    override func getPlanObjectName() -> String {
        return planTrainingName
    }
    
    override func getParameters() -> [String : Any] {
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
            "sessionId": Int64(sessionId),
            "planElements": planElementList ?? ""
        ]
    }
}
