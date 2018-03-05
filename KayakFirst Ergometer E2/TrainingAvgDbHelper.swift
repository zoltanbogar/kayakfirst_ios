//
//  TrainingAvgDbHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingAvgDbHelper: BaseDbHelper<TrainingAvg> {
    
    private let sessionId: Double
    
    init(sessionId: Double) {
        self.sessionId = sessionId
    }
    
    override func run() -> TrainingAvg? {
        return TrainingAvgDbLoader.sharedInstance.getTrainingAvgBySessionId(sessionId: sessionId)
    }
    
}
