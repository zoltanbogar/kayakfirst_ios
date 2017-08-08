//
//  ManagerModifyPlanSave.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerModifyPlanSave: ManagerModifyPlan {
    
    //MARK: functions
    override func modifyLocale() {
        if let plan = data {
            let deletedRow = planDbLoader.deletePlan(plan: plan)
            
            if deletedRow > 0 {
                isEdit = true
            }
            
            planDbLoader.addData(data: plan)
        }
    }
    
    override func runServer(pointers: [String]?) -> Bool {
        var serverWasReachableUpload = true
        var serverWasReachableEdit = true
        
        if let pointersValue = pointers {
            var planListUpload = [Plan]()
            var planListEdit = [Plan]()
            
            for pointer in pointersValue {
                let isEdit = getIsEditFromPointer(pointer: pointer)
                
                var plan: Plan? = nil
                let planArrayList = planDbLoader.loadData(predicate: planDbLoader.getIdPredicate(planId: removeEditPointer(pointer: pointer)))
                if planArrayList != nil && planArrayList!.count > 0 {
                    plan = planArrayList![0]
                }
                
                if plan != nil {
                    if isEdit {
                        planListEdit.append(plan!)
                    } else {
                        planListUpload.append(plan!)
                    }
                }
            }
            
            if planListUpload.count > 0 {
                let uploadPlan = UploadPlan(planList: planListUpload)
                uploadPlan.run()
                serverWasReachableUpload = serverWasReachableUpload && uploadPlan.serverWasReachable
            }
            
            for planToEdit in planListEdit {
                let editPlan = EditPlan(plan: planToEdit)
                editPlan.run()
                serverWasReachableEdit = serverWasReachableEdit && editPlan.serverWasReachable
            }
        }
        return serverWasReachableUpload && serverWasReachableEdit
    }
    
    override func getUploadType() -> UploadType {
        return UploadType.planSave
    }
    
}
