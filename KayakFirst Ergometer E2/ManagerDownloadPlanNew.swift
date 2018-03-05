//
//  ManagerDownloadPlanNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 26..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerDownloadPlanNew<DATA>: ManagerDownload<DATA> {
    
    //MARK: constants
    private let timeCacheMillis: Double = 60 * 60 * 1000 //60 mins
    private let keyCache = "key_cache_plan"
    
    //MARK: properties
    private let preferences = UserDefaults.standard
    let eventDbLoader = EventDbLoader.sharedInstance
    let planDbLoader = PlanDbLoader.sharedInstance
    let planElementDbLoader = PlanElementDbLoader.sharedInstance
    
    //MARK: abstract functions
    func getDataFromLocale() -> DATA? {
        fatalError("must be implemented")
    }
    
    //MARK: functions
    override func getData() -> DATA? {
        if isCacheInvalid() && !shouldWaitForStack() {
            let serverPlans = downloadServerPlans()
            let serverEvents = downloadServerEvents()
            
            if serverError == nil {
                deleteLocalePlans()
                deleteLocaleEvents()
                
                savePlans(plans: serverPlans)
                saveEvents(events: serverEvents)
                
                setCacheValid()
            }
        }
        
        return getDataFromLocale()
    }
    
    private func downloadServerPlans() -> [Plan]? {
        let downloadPlanByName = DownloadPlanByName(name: "")
        let planArrayList = downloadPlanByName.run()
        serverError = downloadPlanByName.error
        
        return planArrayList
    }
    
    private func downloadServerEvents() -> [Event]? {
        let downloadEventByTimestamp = DownloadEventByTimestamp(timestampFrom: 0, timestampTo: Double(INT64_MAX))
        let events = downloadEventByTimestamp.run()
        serverError = downloadEventByTimestamp.error
        
        return events
    }
    
    private func deleteLocalePlans() {
        planDbLoader.deleteUserData()
    }
    
    private func deleteLocaleEvents() {
        eventDbLoader.deleteUserData()
    }
    
    private func savePlans(plans: [Plan]?) {
        planDbLoader.addPlanList(planList: plans)
    }
    
    private func saveEvents(events: [Event]?) {
        eventDbLoader.addDataList(dataList: events)
    }
    
    private func shouldWaitForStack() -> Bool {
        return ManagerUpload.hasStackPlan()
    }
    
    func isCacheInvalid() -> Bool {
        let cacheTimestamp = preferences.double(forKey: getKeyCacheWithUserId())
        let timeDiff = currentTimeMillis() - cacheTimestamp
        
        return timeDiff >= timeCacheMillis
    }
    
    private func setCacheValid() {
        preferences.set(currentTimeMillis(), forKey: getKeyCacheWithUserId())
        preferences.synchronize()
    }
    
    private func getKeyCacheWithUserId() -> String {
        return ManagerUpload.getStaticDbUpload(db: keyCache)
    }
    
}
