//
//  EventManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class EventManager: BaseCalendarManager<PlanEvent> {
    
    //MARK: init
    static let sharedInstance = EventManager()
    private override init() {
        //private constructor
    }
    
    //MARK: functions
    override func getDays() -> BaseManagerType {
        let manager = ManagerDownloadEventDaysNew()
        runDownloadNew(managerDownload: manager, managerCallBack: daysCallback)
        
        return EventManagerType.download_event_days
    }
    
    override func getDataList(timestampObject: TimestampObject?) -> BaseManagerType {
        let manager = ManagerDownloadEventByTimestampNew(timestampObject: timestampObject)
        runDownloadNew(managerDownload: manager, managerCallBack: dataListCallback)
        return EventManagerType.download_event
    }
    
    func saveEvent(event: Event, managerCallBack: ((_ data: Bool?, _ error: Responses?) -> ())?) -> BaseManagerType {
        let managerModifyEventSave = ManagerModifyEventSave(data: event)
        runModify(managerModify: managerModifyEventSave, managerCallBack: managerCallBack)
        return EventManagerType.edit
    }
    
    func deleteEvent(event: Event, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) -> BaseManagerType {
        let managerModify = ManagerModifyEventDelete(data: event)
        runModify(managerModify: managerModify, managerCallBack: managerCallback)
        return EventManagerType.delete
    }
}
