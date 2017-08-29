//
//  ManagerDownloadPlan.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerDownloadPlan<E>: ManagerDownload<E> {
    
    //MARK: constants
    let eventDbLoader = EventDbLoader.sharedInstance
    let planDbLoader = PlanDbLoader.sharedInstance
    let planElementDbLoader = PlanElementDbLoader.sharedInstance
    
    //MARK: properties
    private var planList: [Plan]?
    private var eventList: [Event]?
    
    //MARK: override functions
    override func runServer() -> E? {
        planList = downloadPlans()
        eventList = downloadEvents(timestampFrom: 0, timestampTo: Double(INT64_MAX))
        
        return nil
    }
    
    override func shouldWaitForStack() -> Bool {
        return ManagerUpload.hasStackPlan()
    }
    
    override func deleteDataFromLocale() {
        planDbLoader.deleteAllWithoutPlanTraining()
        planElementDbLoader.deleteAllWithoutPlanTraining()
        eventDbLoader.deleteAll()
    }
    
    override func addDataToLocale(data: E?) {
        planDbLoader.addPlanList(planList: planList)
        eventDbLoader.addDataList(dataList: eventList)
    }
    
    override func getKeyCache() -> String {
        return "manager_download_plan"
    }
    
    //MARK: functions
    private func downloadPlans() -> [Plan]? {
        let downloadPlanByName = DownloadPlanByName(name: "")
        let planArrayList = downloadPlanByName.run()
        serverError = downloadPlanByName.error
        
        return planArrayList
    }
    
    private func downloadEvents(timestampFrom: Double, timestampTo: Double) -> [Event]? {
        let downloadEventByTimestamp = DownloadEventByTimestamp(timestampFrom: timestampFrom, timestampTo: timestampTo)
        let events = downloadEventByTimestamp.run()
        serverError = downloadEventByTimestamp.error
        
        return events
    }
}
