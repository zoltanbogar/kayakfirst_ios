//
//  PlanManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanManager: BaseManager {
    
    //MARK: init
    static let sharedInstance = PlanManager()
    private override init() {
        //private constructor
    }
    
    //MARK: functions
    func getPlanByName(name: String, managerCallBack: ((_ data: [Plan]?, _ error: Responses?) -> ())?) -> BaseManagerType {
        let manager = ManagerDownloadPlanByName(name: name)
        runDownload(managerDownload: manager, managerCallBack: managerCallBack)
        return PlanManagerType.download_plan
    }
    
    func savePlan(plan: Plan, managerCallBack: ((_ data: Bool?, _ error: Responses?) -> ())?) -> BaseManagerType {
        let manager = ManagerModifyPlanSave(data: plan)
        runModify(managerModify: manager, managerCallBack: managerCallBack)
        return PlanManagerType.edit
    }
    
    func savePlanTraining(planTraining: PlanTraining) {
        let manager = ManagerModifyPlanTrainingSave(data: planTraining)
        runModify(managerModify: manager, managerCallBack: nil)
    }
    
    func deletePlan(plan: Plan, managerCallBack: ((_ data: Bool?, _ error: Responses?) -> ())?) -> BaseManagerType {
        let manager = ManagerModifyPlanDelete(data: plan)
        runModify(managerModify: manager, managerCallBack: managerCallBack)
        return PlanManagerType.delete
    }
}
