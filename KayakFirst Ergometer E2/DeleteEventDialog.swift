//
//  DeleteEventDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DeleteEventDialog: BaseDialog {
    
    static func showDeleteEventDialog(viewController: UIViewController, planEvent: PlanEvent, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        DeleteEventDialog(planEvent: planEvent, managerCallback: managerCallback).show(viewController: viewController)
    }
    
    //MARK: properties
    private let planEvent: PlanEvent
    private let managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    
    //MARK: init
    private init(planEvent: PlanEvent, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        self.planEvent = planEvent
        self.managerCallback = managerCallback
        
        let originalTitle = getString("dialog_event_delete_title")
        let titleWithName = "\(originalTitle) \(planEvent.plan.name ?? "")?"
        super.init(title: titleWithName, message: nil)
        showPositiveButton(title: getString("other_delete"))
        showNegativeButton(title: getString("other_cancel"))
    }
    
    override func btnPosAction() {
        EventManager.sharedInstance.deleteEvent(event: planEvent.event, managerCallback: managerCallback)
    }
}
