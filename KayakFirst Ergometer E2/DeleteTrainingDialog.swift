//
//  DeleteTrainingDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DeleteTrainingDialog: BaseDialog {
    
    static func showDeleteTrainingDialog(viewController: UIViewController, sumTraining: SumTraining, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        DeleteTrainingDialog(sumTraining: sumTraining, managerCallback: managerCallback).show(viewController: viewController)
    }
    
    //MARK: properties
    private let sumTraining: SumTraining
    private let managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    
    //MARK: init
    private init(sumTraining: SumTraining, managerCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        self.sumTraining = sumTraining
        self.managerCallback = managerCallback
        
        let originalTitle = getString("dialog_event_delete_title")
        let titleWithName = "\(originalTitle) ?"
        super.init(title: titleWithName, message: nil)
        showPositiveButton(title: getString("other_delete"))
        showNegativeButton(title: getString("other_cancel"))
    }
    
    override func onPositiveButtonClicked(uiAlertAction: UIAlertAction) {
        TrainingManager.sharedInstance.deleteTraining(sumTraining: sumTraining, managerCallback: managerCallback)
    }
}
