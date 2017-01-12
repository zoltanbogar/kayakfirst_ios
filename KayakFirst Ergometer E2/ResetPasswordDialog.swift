//
//  ResetPasswordDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class ResetPasswordDialog: BaseDialog {
    
    var textField: UITextField?
    
    init() {
        super.init(title: try! getString("dialog_title_reset_password"), message: nil)
        showPositiveButton(title: try! getString("user_reset_password"))
        showNegativeButton(title: try! getString("cancel"))
        
        alertController?.addTextField(configurationHandler: initTextField)
        
        setEnabledPositive(isEnabled: false)
    }
    
    private func initTextField(textField: UITextField) {
        textField.keyboardType = .emailAddress
        self.textField = textField
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        setEnabledPositive(isEnabled: isValidEmail(email: textField.text))
    }
    
    override func onPositiveButtonClicked(uiAlertAction: UIAlertAction) {
        //TODO
        log("DIALOG", "\(textField?.text)")
    }
    
}
