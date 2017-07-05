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
    
    override func runServer(pointers: [String]?) -> String? {
        var error: Responses? = nil
        
        if let pointersValue = pointers {
            var eventIds = [String]()
            
            for pointer in pointersValue {
                let pointerValue = removeEditPointer(pointer: pointer)
                
                eventIds.append(pointerValue)
            }
            
            if eventIds.count > 0 {
                let deleteEvent = DeleteEvent(eventIds: eventIds)
                deleteEvent.run()
                error = deleteEvent.error
            }
        }
        return error?.rawValue
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.eventDelete
    }
    
}
