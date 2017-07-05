//
//  ManagerModifyEventSave.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerModifyEventSave: ManagerModifyEvent {
    
    override func modifyLocale() {
        let deletedRow = eventDbLoader.deleteData(predicate: eventDbLoader.getIdPredicate(eventId: data?.eventId))
        
        if deletedRow > 0 {
            isEdit = true
        }
        
        eventDbLoader.addData(data: data)
    }
    
    override func runServer(pointers: [String]?) -> String? {
        var error: Responses? = nil
        
        if let pointersValues = pointers {
            var eventListUpload = [Event]()
            var eventListEdit = [Event]()
            
            for pointer in pointersValues {
                var isEdit = getIsEditFromPointer(pointer: pointer)
                
                let events = eventDbLoader.loadData(predicate: eventDbLoader.getIdPredicate(eventId: removeEditPointer(pointer: pointer)))
                var event: Event? = nil
                if events != nil && events!.count > 0 {
                    event = events![0]
                }
                
                if event != nil {
                    if isEdit {
                        eventListEdit.append(event!)
                    } else {
                        eventListUpload.append(event!)
                    }
                }
            }
            
            if eventListUpload.count > 0 {
                let uploadEvent = UploadEvent(eventList: eventListUpload)
                uploadEvent.run()
                error = uploadEvent.error
            }
            
            for eventToEdit in eventListEdit {
                let editEvent = EditEvent(event: eventToEdit)
                editEvent.run()
                error = editEvent.error
            }
        }
        return error?.rawValue
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.eventSave
    }
    
}
