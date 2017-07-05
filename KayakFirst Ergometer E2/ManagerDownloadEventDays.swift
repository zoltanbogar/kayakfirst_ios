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
        return EventDbLoader.sharedInstance.getEventDays()
    }
    
    override func runServer() -> [Double]? {
        let downloadEventDays = DownloadEventDays()
        
        daysList = downloadEventDays.run()
        
        serverError = downloadEventDays.error
        
        return daysList
    }
    
    override func getKeyCache() -> String {
        return "manager_download_event_days"
    }
    
}
