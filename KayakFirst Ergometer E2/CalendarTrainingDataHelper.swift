//
//  CalendarTrainingDataHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalendarTrainingDataHelper: BaseCalendarDateHelper<ViewTrainingCalendarListLayout, SumTrainingNew> {
    
    override func getManager() -> BaseCalendarManager<SumTrainingNew> {
        return TrainingManager.sharedInstance
    }
    
}
