//
//  TrainingCalendarListView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingCalendarListView: BaseCalendarListView<ViewTrainingCalendarListLayout, SumTraining> {
    
    override func getContentLayout(contentView: UIView) -> ViewTrainingCalendarListLayout {
        return ViewTrainingCalendarListLayout(contentView: contentView)
    }
    
    override func getTableView() -> BaseCalendarTableView<SumTraining> {
        return contentLayout!.tableView
    }
    
    override func getProgressBar() -> AppProgressBar {
        return contentLayout!.progressBar
    }
    
    override func getManager() -> BaseCalendarManager<SumTraining> {
        return TrainingManager.sharedInstance
    }
    
    override func getDataTimestampToCheck(data: SumTraining) -> Double {
        return data.sessionId
    }
    
}
