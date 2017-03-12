//
//  LocationSettingsDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class LocationSettingsDialog: BaseDialog {
    
    //MARK: init
    init() {
        super.init(title: nil, message: getString("settings_location_ios"))
        
        showPositiveButton(title: getCapitalizedString("other_ok"))
    }
}
