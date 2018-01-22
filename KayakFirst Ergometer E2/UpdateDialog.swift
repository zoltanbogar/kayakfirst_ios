//
//  UpdateDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 22..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func showUpdateDialog(actualVersionCode: Int?) {
    let appVersionCode = Int(AppDelegate.buildString)
    
    if appVersionCode != nil && actualVersionCode != nil {
        if actualVersionCode! > appVersionCode! {
            UpdateDialog().show()
        }
    }
}

class UpdateDialog: BaseDialog {
    fileprivate init() {
        super.init(title: getString("dialog_update_title"), message: nil)
        
        showPositiveButton(title: getString("dialog_update_pos_button").capitalized)
        showNegativeButton(title: getString("other_cancel"))
    }
    
    override func btnPosAction() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/kayakfirst-paddle-app/id1229142021?mt=8"),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}
