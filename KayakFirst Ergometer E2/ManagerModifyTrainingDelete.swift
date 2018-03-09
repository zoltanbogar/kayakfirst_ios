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
    private let sumTrainingDbLoader = SumTrainingDbLoader.sharedInstance
    
    //MARK: functions
    override func modifyLocale() {
        if let sumTraining = data {
            sumTrainingDbLoader.deleteDataBySessionId(sessionId: sumTraining.sessionId)
        }
    }
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachableTraining = true
        
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
            }
        }
        return serverWasReachableTraining
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
