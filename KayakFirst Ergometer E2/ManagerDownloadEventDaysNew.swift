//
//  ManagerDownloadEventDaysNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 26..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerDownloadEventDaysNew: ManagerDownloadPlanNew<DaysObject> {
    
    override func getDataFromLocale() -> DaysObject? {
        return createDaysObject(localeIds: eventDbLoader.getEventDays())
    }
    
    override func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadEventDaysNew
    }
    
    private func createDaysObject(localeIds: [Double]) -> DaysObject {
        var daysObjcet = DaysObject()
        
        for localeId in localeIds {
            let midnightTime = DateFormatHelper.getZeroHour(timeStamp: localeId)
            
            var timestampObject = daysObjcet[midnightTime]
            
            if timestampObject == nil {
                timestampObject = TimestampObject()
            }
            
            timestampObject?.addLocaleId(timestampLocale: localeId)
            
            daysObjcet[midnightTime] = timestampObject
        }
        
        return daysObjcet
    }
    
}
