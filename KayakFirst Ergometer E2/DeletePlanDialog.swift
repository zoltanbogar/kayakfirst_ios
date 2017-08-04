//
//  DeletePlanDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DeletePlanDialog: BaseDialog {
    
    static func showDeletePlanDialog(viewController: UIViewController, plan: Plan, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        DeletePlanDialog(plan: plan, managerCallback: managerCallback).show(viewController: viewController)
    }
    
    //MARK: properties
    private let plan: Plan
    private let managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    
    //MARK: init
    private init(plan: Plan, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        self.plan = plan
        self.managerCallback = managerCallback
        
        let originalTitle = getString("dialog_event_delete_title")
        let titleWithName = "\(originalTitle) \(plan.name ?? "")?"
        super.init(title: titleWithName, message: nil)
        showPositiveButton(title: getString("other_delete"))
        showNegativeButton(title: getString("other_cancel"))
    }
    
    override func btnPosAction() {
        PlanManager.sharedInstance.deletePlan(plan: plan, managerCallBack: managerCallback)
    }
}
