//
//  EventManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class EventManager: BaseManager {
    
    //MARK: init
    static let sharedInstance = EventManager()
    private override init() {
        //private constructor
    }
    
    //MARK: callback
    var planEventCallback: ((_ data: [PlanEvent]?, _ error: Responses?) -> ())?
    var eventDaysCallback: ((_ data: [Double]?, _ error: Responses?) -> ())?
    
    //MARK: functions
    func getEventDays() -> BaseManagerType {
        let managerDownloadEventDays = ManagerDownloadEventDays()
        runDownload(managerDownload: managerDownloadEventDays, managerCallBack: eventDaysCallback)
        return EventManagerType.download_event_days
    }
    
    func getEventByTimestamp(timestampFrom: Double, timestampTo: Double) -> BaseManagerType {
        let managerDownloadEventByTimestamp = ManagerDownloadEventByTimestamp(timestampFrom: timestampFrom, timestampTo: timestampTo)
        runDownload(managerDownload: managerDownloadEventByTimestamp, managerCallBack: planEventCallback)
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
