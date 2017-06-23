//
//  ResetPasswordDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
class ResetPasswordDialog: BaseDialog {
    
    private var textField: UITextField?
    var handler: ((_ email: String) ->())?
    
    init() {
        super.init(title: getString("dialog_title_reset_password"), message: nil)
        showPositiveButton(title: getString("user_reset_password"))
        showNegativeButton(title: getString("other_cancel"))
        
        alertController?.addTextField(configurationHandler: initTextField)
        
        setEnabledPositive(isEnabled: false)
    }
    
    private func initTextField(textField: UITextField) {
        textField.keyboardType = .emailAddress
        self.textField = textField
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        setEnabledPositive(isEnabled: Validate.isValidEmail(email: textField.text))
    }
    
    override func onPositiveButtonClicked(uiAlertAction: UIAlertAction) {
        if let emailHandler = handler {
            emailHandler(textField!.text!)
        }
    }
    
}
