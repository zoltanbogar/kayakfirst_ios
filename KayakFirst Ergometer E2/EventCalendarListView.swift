//
//  EventCalendarListView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class EventCalendarListView: BaseCalendarListView<ViewEventCalendarListLayout, PlanEvent> {
    
    override func getContentLayout(contentView: UIView) -> ViewEventCalendarListLayout {
        return ViewEventCalendarListLayout(contentView: contentView)
    }
    
    override func getTableView() -> BaseCalendarTableView<PlanEvent> {
        return contentLayout!.tableView
    }
    
    override func getProgressBar() -> AppProgressBar {
        return contentLayout!.progressBar
    }
    
    override func getManager() -> BaseCalendarManager<PlanEvent> {
        return EventManager.sharedInstance
    }
    
    override func getDataTimestampToCheck(data: PlanEvent) -> Double {
        return data.event.timestamp
    }
    
}
