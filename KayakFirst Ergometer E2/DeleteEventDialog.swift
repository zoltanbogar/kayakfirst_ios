//
//  DeleteEventDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DeleteEventDialog: BaseDialog {
    
    static func showDeleteEventDialog(viewController: UIViewController, event: Event, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        DeleteEventDialog(event: event, managerCallback: managerCallback).show(viewController: viewController)
    }
    
    //MARK: properties
    private let event: Event
    private let managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    
    //MARK: init
    private init(event: Event, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        self.event = event
        self.managerCallback = managerCallback
        
        let originalTitle = getString("dialog_event_delete_title")
        let titleWithName = "\(originalTitle) \(event.name ?? "")?"
        super.init(title: titleWithName, message: nil)
        showPositiveButton(title: getString("other_delete"))
        showNegativeButton(title: getString("other_cancel"))
    }
    
    override func btnPosAction() {
        EventManager.sharedInstance.deleteEvent(event: event, managerCallback: managerCallback)
    }
}
