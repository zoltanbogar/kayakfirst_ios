//
//  ManagerModifyEventDelete.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerModifyEventDelete: ManagerModifyEvent {
    
    override func modifyLocale() {
        eventDbLoader.deleteData(predicate: eventDbLoader.getIdPredicate(eventId: data?.eventId))
    }
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachable = true
        
        if let pointersValue = pointers {
            var eventIds = [String]()
            
            for pointer in pointersValue {
                let pointerValue = removeEditPointer(pointer: pointer)
                
                eventIds.append(pointerValue)
            }
            
            if eventIds.count > 0 {
                let deleteEvent = DeleteEvent(eventIds: eventIds)
                deleteEvent.run()
                serverWasReachable = deleteEvent.serverWasReachable
            }
        }
        return serverWasReachable
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.eventDelete
    }
    
}
