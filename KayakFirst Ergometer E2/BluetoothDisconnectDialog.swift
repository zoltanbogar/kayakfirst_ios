//
//  BluetoothDisconnectDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BluetoothDisconnectDialog: BaseDialog {
    
    //MARK: init
    init() {
        let title = getString("dialog_title_bluetooth_disconnect")
        let message = getString("dialog_message_bluetooth_disconnect")
        super.init(title: title, message: message)
        showPositiveButton(title: getString("other_yes").capitalized)
        showNegativeButton(title: getString("other_no").capitalized)
    }
    
    override func btnPosAction() {
        ErgometerServiceOld.sharedInstance.disconnectBluetoothn()
    }
}
