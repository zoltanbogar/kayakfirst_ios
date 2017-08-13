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
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachableTraining = true
        var serverWasReachableTrainingAvg = true
        
        if let pointersValue = pointers {
            var sessionIds = [String]()
            
            for pointer in pointersValue {
                let pointerValue = removeEditPointer(pointer: pointer)
                
                sessionIds.append(pointerValue)
            }
            
            if sessionIds.count > 0 {
                let deleteTraining = DeleteTraining(sessionIds: sessionIds)
                deleteTraining.run()
                serverWasReachableTraining = deleteTraining.serverWasReachable
                
                let deleteTrainingAvg = DeleteTrainingAvg(sessionIds: sessionIds)
                deleteTrainingAvg.run()
                serverWasReachableTrainingAvg = deleteTrainingAvg.serverWasReachable
            }
        }
        return serverWasReachableTraining && serverWasReachableTrainingAvg
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.trainingDelete
    }
    
    func getDeletedSessionIds() -> [Double]? {
        var sessionIds: [Double]? = nil
        
        let pointers = getPointers()
        
        if pointers != nil {
            for s in pointers! {
                if sessionIds == nil {
                    sessionIds = [Double]()
                }
                let pointerValue = removeEditPointer(pointer: s)
                
                sessionIds!.append(Double(pointerValue)!)
            }
        }
        
        return sessionIds
    }
}
