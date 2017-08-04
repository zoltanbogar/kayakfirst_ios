//
//  AddEventDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class AddEventDialog: BaseDialog {
    
    //MARK: init
    init() {
        super.init(title: nil, message: getString("dialog_event_add_message"))
        
        showPositiveButton(title: getCapitalizedString("other_yes"))
        showNegativeButton(title: getCapitalizedString("other_no"))
    }
}
