//
//  ManagerDownloadEventDays.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerDownloadEventDays: ManagerDownloadTrainingDays {
    
    override func getDataFromLocale() -> [Double]? {
        localeDaysList = EventDbLoader.sharedInstance.getEventDays()
        return localeDaysList
    }
    
    override func getServerService() -> ServerService<[Double]> {
        return DownloadEventDays()
    }
    
    override func deleteDataByTimestamp(timestampFrom: Double, timestampTo: Double) {
        let eventDbLoader = EventDbLoader.sharedInstance
        eventDbLoader.deleteData(predicate: eventDbLoader.getEventBetweenTimestampPredicate(timestampFrom: timestampFrom, timestampTo: timestampTo))
    }
    
    override func getKeyCache() -> String {
        return "manager_download_event_days"
    }
    
}
