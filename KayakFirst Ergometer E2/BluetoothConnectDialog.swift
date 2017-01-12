//
//  BluetoothConnectDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BluetoothConnectDialog: ProgressDialog {
    
    init() {
        super.init(title: try! getString("dialog_title_bluetooth_connecting"))
    }
    
}
