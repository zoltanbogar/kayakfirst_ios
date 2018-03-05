//
//  ManagerDownloadEventByTimestampNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 26..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class ManagerDownloadEventByTimestampNew: ManagerDownloadPlanNew<[PlanEvent]> {
    
    //MARK: properties
    private let timestamps: [Double]?
    
    //MARK: init
    init(timestampObject: TimestampObject?) {
        self.timestamps = timestampObject?.timestampsLocale
    }
    
    override func getDataFromLocale() -> [PlanEvent]? {
        var planEvents = [PlanEvent]()
        
        let events = eventDbLoader.getEventsByTimestamps(timestamps: timestamps)
        
        if let eventValue = events {
            for event in eventValue {
                let planArrayList = planDbLoader.loadData(predicate: getQueryPlanId(planId: event.planId))
                
                if planArrayList != nil && planArrayList?.count == 1 {
                    let plan = planArrayList![0]
                    
                    let planEvent = PlanEvent(event: event, plan: plan)
                    
                    planEvents.append(planEvent)
                }
            }
        }
        
        return planEvents
    }
    
    override func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadEventByTimestampNew
    }
    
    //MARK: helper
    private func getQueryPlanId(planId: String) -> Expression<Bool> {
        return planDbLoader.getIdPredicate(planId: planId)
    }
    
}
