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
    
    //MARK: functions
    func deleteEvent(event: Event, managerCallback: ((_ data: [Bool]?, _ error: Responses?) -> ())?) -> BaseManagerType {
        //TODO
        return EventManagerType.delete
    }
    
}
