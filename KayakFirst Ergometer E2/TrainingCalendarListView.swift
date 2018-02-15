//
//  TrainingCalendarListView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingCalendarListView: BaseCalendarListView<ViewTrainingCalendarListLayout, SumTrainingNew> {
    
    private let trainingManager = TrainingManager.sharedInstance
    
    override func initView() {
        super.initView()
        
        trainingManager.trainingCallback = listCallback
    }
    
    override func getContentLayout(contentView: UIView) -> ViewTrainingCalendarListLayout {
        return ViewTrainingCalendarListLayout(contentView: contentView)
    }
    
    override func getTableView() -> BaseCalendarTableView<SumTrainingNew> {
        return contentLayout!.tableView
    }
    
    override func getProgressBar() -> AppProgressBar {
        return contentLayout!.progressBar
    }
    
    override func callManager(timestamps: [Double]) {
        trainingManager.downloadSumTrainings(sessionIds: timestamps)
    }
    
    override func getDataTimestampToCheck(data: SumTrainingNew) -> Double {
        return data.sessionId
    }
    
}
