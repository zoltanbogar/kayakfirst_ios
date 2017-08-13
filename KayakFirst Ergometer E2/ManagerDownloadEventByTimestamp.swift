//
//  ManagerDownloadEventByTimestamp.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class ManagerDownloadEventByTimestamp: ManagerDownloadPlan<[PlanEvent]>, ManagerDownloadProtocol {
    
    //MARK: properties
    private let timestampFrom: Double
    private let timestampTo: Double
    
    private var planIds: [String]?
    
    //MARK: init
    init(timestampFrom: Double, timestampTo: Double) {
        self.timestampFrom = timestampFrom
        self.timestampTo = timestampTo
    }
    
    //MARK: funtions
    override func getDataFromLocale() -> [PlanEvent]? {
        var planEvents = [PlanEvent]()
        
        let events = eventDbLoader.loadData(predicate: getQueryEventTimestamp())
        
        if let eventValue = events {
            for event in eventValue {
                let planArrayList = planDbLoader.loadData(predicate: getQueryPlanId(planId: event.planId))
                
                if planArrayList != nil && planArrayList?.count == 1 {
                    let plan = planArrayList![0]
                    
                    let planEvent = PlanEvent(event: event, plan: plan)
                    
                    planEvents.append(planEvent)
                    
                    if planIds == nil {
                        planIds = [String]()
                    }
                    
                    planIds?.append(plan.planId)
                }
            }
        }
        
        return planEvents
    }
    
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadEventByTimestamp
    }
    
    //MARK: helper
    private func getQueryEventTimestamp() -> Expression<Bool> {
        return eventDbLoader.getEventBetweenTimestampPredicate(timestampFrom: timestampFrom, timestampTo: timestampTo)
    }
    
    private func getQueryPlanId(planId: String) -> Expression<Bool> {
        return planDbLoader.getIdPredicate(planId: planId)
    }
}
