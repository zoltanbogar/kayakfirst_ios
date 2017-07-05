//
//  ManagerModifyTrainingDelete.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerModifyTrainingDelete: ManagerModifyEditable<SumTraining> {
    
    //MARK: constants
    private let trainingDbLoader = TrainingDbLoader.sharedInstance
    private let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
    
    //MARK: functions
    override func modifyLocale() {
        if let sumTraining = data {
            trainingDbLoader.deleteData(predicate: trainingDbLoader.getPredicateSessionId(sessionId: sumTraining.sessionId))
        trainingAvgDbLoader.deleteData(predicate: trainingAvgDbLoader.getSessionIdPredicate(sessionId: sumTraining.sessionId))
        }
    }
    
    override func runServer(pointers: [String]?) -> String? {
        var error: Responses? = nil
        
        if let pointersValue = pointers {
            var sessionIds = [String]()
            
            for pointer in pointersValue {
                let pointerValue = removeEditPointer(pointer: pointer)
                
                sessionIds.append(pointerValue)
            }
            
            if sessionIds.count > 0 {
                let deleteTraining = DeleteTraining(sessionIds: sessionIds)
                deleteTraining.run()
                error = deleteTraining.error
                
                let deleteTrainingAvg = DeleteTrainingAvg(sessionIds: sessionIds)
                deleteTraining.run()
                error = deleteTrainingAvg.error
            }
        }
        return error?.rawValue
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingDelete
    }
}
