//
//  CalendarEventDataHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalendarEventDataHelper: BaseCalendarDateHelper<ViewEventCalendarListLayout, PlanEvent> {
    
    override func getManager() -> BaseCalendarManager<PlanEvent> {
        return EventManager.sharedInstance
    }
    
}
