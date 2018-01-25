//
//  SystemInfoDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 25..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class SystemInfoDialog: BaseDialog {
    
    class func showSystemInfoDialog() {
        let systemInfo = AppLog.getSystemInfo()
        
        if let systemInfo = systemInfo {
            let title = getString("feedback_system_information").capitalized
            let message = SystemInfoDialog.getMessage(systemInfo: systemInfo)
            
            SystemInfoDialog(title: title, message: message).show()
        }
    }
    
    override init(title: String?, message: String?) {
        super.init(title: title, message: message)
        
        showPositiveButton(title: getString("other_ok"))
    }
    
    private class func getMessage(systemInfo: SystemInfo) -> String {
        let versionCode = "\(getString("feedback_version_code")) \n \(systemInfo.versionCode)"
        let versionName = "\(getString("feedback_version_name")) \n \(systemInfo.versionName)"
        let timestamp = "\(getString("feedback_timestamp")) \n \(DateFormatHelper.getDate(dateFormat: DateFormatHelper.dateTimeFormat, timeIntervallSince1970: systemInfo.timestamp))"
        let locale = "\(getString("feedback_locale")) \n \(systemInfo.locale)"
        let brand = "\(getString("feedback_brand")) \n \(systemInfo.brand)"
        let model = "\(getString("feedback_model")) \n \(systemInfo.model)"
        let osVersion = "\(getString("feedback_os_version")) \n \(systemInfo.osVersion)"
        let userName = "\(getString("feedback_username")) \n \(systemInfo.userName)"
        
        let systemInfoString = versionCode + "\n\n" + versionName + "\n\n" + timestamp + "\n\n" + locale + "\n\n" + brand + "\n\n" + model + "\n\n" + osVersion + "\n\n" + userName
        
        return systemInfoString
    }
    
}
