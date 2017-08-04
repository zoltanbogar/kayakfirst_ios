//
//  PlanNoElementsDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanNoElementsDialog: BaseDialog {
    
    //MAK: init
    init() {
        super.init(title: nil, message: getString("dialog_plan_no_elements"))
        
        showPositiveButton(title: getString("other_ok"))
    }
}
