//
//  ManagerDownloadEventByTimestamp.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class ManagerDownloadEventByTimestamp: ManagerDownload<[PlanEvent]>, ManagerDownloadProtocol {
    
    //MARK: constants
    private let eventDbLoader = EventDbLoader.sharedInstance
    private let planDbLoader = PlanDbLoader.sharedInstance
    
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
    
    override func runServer() -> [PlanEvent]? {
        var planEvents = [PlanEvent]()
        
        let downloadEventByTimestamp = DownloadEventByTimestamp(timestampFrom: timestampFrom, timestampTo: timestampTo)
        let events = downloadEventByTimestamp.run()
        serverError = downloadEventByTimestamp.error
        
        if let eventValue = events {
            for event in eventValue {
                let downloadPlanById = DownloadPlanById(planId: event.planId)
                let plan = downloadPlanById.run()
                serverError = downloadPlanById.error
                
                if let planValue = plan {
                    let planEvent = PlanEvent(event: event, plan: planValue)
                    
                    planEvents.append(planEvent)
                }
            }
        }
        
        return planEvents
    }
    
    override func addDataToLocale(data: [PlanEvent]?) {
        if let planEvents = data {
            for planEvent in planEvents {
                planDbLoader.deletePlan(plan: planEvent.plan)
                planDbLoader.addData(data: planEvent.plan)
                
                eventDbLoader.deleteData(predicate: getQueryEventId(eventId: planEvent.event.eventId))
                eventDbLoader.addData(data: planEvent.event)
            }
        }
    }
    
    override func deleteDataFromLocale() {
        if planIds != nil {
            for s in planIds! {
                planDbLoader.deleteData(predicate: getQueryPlanId(planId: s))
            }
        }
        
        eventDbLoader.deleteData(predicate: getQueryEventTimestamp())
    }
    
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadEventByTimestamp &&
        self.timestampFrom == (anotherManagerDownload as! ManagerDownloadEventByTimestamp).timestampFrom &&
        self.timestampTo == (anotherManagerDownload as! ManagerDownloadEventByTimestamp).timestampTo
    }
    
    override func getKeyCache() -> String {
        return "manager_download_event_timestamp_\(timestampFrom)_\(timestampTo)"
    }
    
    //MARK: helper
    private func getQueryEventTimestamp() -> Expression<Bool> {
        return eventDbLoader.getEventBetweenTimestampPredicate(timestampFrom: timestampFrom, timestampTo: timestampTo)
    }
    
    private func getQueryPlanId(planId: String) -> Expression<Bool> {
        return planDbLoader.getIdPredicate(planId: planId)
    }
    
    private func getQueryEventId(eventId: String) -> Expression<Bool> {
        return eventDbLoader.getIdPredicate(eventId: eventId)!
    }
    
}
