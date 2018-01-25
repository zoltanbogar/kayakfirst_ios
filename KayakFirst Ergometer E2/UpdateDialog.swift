//
//  UpdateDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 22..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class UpdateDialog: BaseDialog {
    
    //MARK: public class function
    class func showUpdateDialog(actualVersionCode: Int?) {
        let appVersionCode = Int(AppDelegate.buildString)
        
        if appVersionCode != nil && actualVersionCode != nil {
            if actualVersionCode! > appVersionCode! && UpdateDialog.isReminderTimestampInvalid() {
                UpdateDialog().show()
            }
        }
    }

    
    //MARK: constants
    private static let dbUpdateReminder = "db_update_reminder"
    private static let keyReminderTimestamp = "key_reminder_timestamp"
    private static let reminderDays: Double = 7
    
    //MARK: properties
    private static let preferences = UserDefaults.standard
    
    //MARK: init
    fileprivate init() {
        super.init(title: getString("dialog_update_title"), message: nil)
        
        showPositiveButton(title: getString("dialog_update_pos_button").capitalized)
        showNegativeButton(title: getString("other_cancel"))
        
        showNeutralButton()
    }
    
    //MARK: functions
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
    
    private func showNeutralButton() {
        alertController?.addAction(UIAlertAction(title: getString("dialog_update_neut_button").capitalized, style: UIAlertActionStyle.default, handler: onNeutralButtonClicked))
    }
    
    private func onNeutralButtonClicked(uiAlertAction: UIAlertAction) {
        UpdateDialog.setReminderTimestamp()
    }
    
    //MARK: private class functions
    private class func isReminderTimestampInvalid() -> Bool {
        let reminderTimestamp = UpdateDialog.preferences.double(forKey: UpdateDialog.keyReminderTimestamp)
        return currentTimeMillis() >= reminderTimestamp
    }
    
    private class func setReminderTimestamp() {
        let oneDayInMillis: Double = 24 * 60 * 60 * 1000
        let reminderTimestamp = currentTimeMillis() + UpdateDialog.reminderDays * oneDayInMillis
        
        UpdateDialog.preferences.set(reminderTimestamp, forKey: UpdateDialog.keyReminderTimestamp)
        UpdateDialog.preferences.synchronize()
    }
    
}
