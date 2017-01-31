//
//  BluetoothDisconnectDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class BluetoothDisconnectDialog: BaseDialog {
    
    init() {
        super.init(title: getString("dialog_title_bluetooth_disconnect"), message: getString("dialog_message_bluetooth_disconnect"))
        
        showNegativeButton(title: getString("other_no"))
        showPositiveButton(title: getString("other_yes"))
    }
    
    override func onPositiveButtonClicked(uiAlertAction: UIAlertAction) {
        //TODO
    }
    
}
