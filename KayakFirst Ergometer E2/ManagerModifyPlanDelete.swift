//
//  ManagerModifyPlanDelete.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerModifyPlanDelete: ManagerModifyPlan {
    
    //MARK: functions
    override func modifyLocale() {
        if let plan = data {
            planDbLoader.deletePlan(plan: plan)
            
            let eventDbLoader = EventDbLoader.sharedInstance
            
            let events = eventDbLoader.getEventsByPlanId(planId: plan.planId)
            
            if let eventsValue = events {
                for event in eventsValue {
                    EventManager.sharedInstance.deleteEvent(event: event, managerCallback: nil)
                }
            }
        }
    }
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachable = true
        
        if let pointersValue = pointers {
            var planIds = [String]()
            
            for pointer in pointersValue {
                let pointerValue = removeEditPointer(pointer: pointer)
                
                planIds.append(pointerValue)
            }
            
            if planIds.count > 0 {
                let deletePlan = DeletePlan(planIds: planIds)
                deletePlan.run()
                serverWasReachable = deletePlan.serverWasReachable
            }
        }
        
        return serverWasReachable
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.planDelete
    }
    
}
