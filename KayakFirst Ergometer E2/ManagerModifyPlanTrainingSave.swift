//
//  ManagerModifyPlanTrainingSave.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerModifyPlanTrainingSave: ManagerModifyPlanTraining {
    
    //MARK: functions
    override func modifyLocale() {
        planTrainingDbLoader.addData(data: data)
    }
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachable = true
        
        if let pointersValue = pointers {
            var planTrainings = [PlanTraining]()
            
            for pointer in pointersValue {
                var planTraining: PlanTraining? = nil
                let planTraininArrayList = planTrainingDbLoader.loadData(predicate: planTrainingDbLoader.getExpressionById(planTrainingId: pointer))
                
                if planTraininArrayList != nil && planTraininArrayList!.count > 0 {
                    planTraining = planTraininArrayList![0]
                }
                
                if let planTrainingValue = planTraining {
                    planTrainings.append(planTrainingValue)
                }
            }
            
            if planTrainings.count > 0 {
                let uploadPlanTraining = UploadPlanTraining(planTrainingList: planTrainings)
                uploadPlanTraining.run()
                serverWasReachable = serverWasReachable && uploadPlanTraining.serverWasReachable
            }
        }
        return serverWasReachable
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.planTrainingSave
    }
    
}
