//
//  NewPasswordDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class NewPasswordDialog: BaseDialog {
    
    private var textFieldCurrent: UITextField?
    private var textFieldNew: UITextField?
    private var textFieldConfirm: UITextField?
    
    var handler: ((_ currentPassword: String, _ newPassword: String) ->())?
    
    init() {
        super.init(title: getString("user_password"), message: nil)
        
        showNegativeButton(title: getString("other_cancel"))
        showPositiveButton(title: getString("other_ok"))
        
        setEnabledPositive(isEnabled: false)
        
        alertController?.addTextField(configurationHandler: initTextFieldCurrent)
        alertController?.addTextField(configurationHandler: initTextFieldNew)
        alertController?.addTextField(configurationHandler: initTextFieldConfirm)
    }
    
    private func initTextFieldCurrent(textField: UITextField) {
        textField.isSecureTextEntry = true
        textField.placeholder = getString("user_password_old")
        self.textFieldCurrent = textField
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func initTextFieldNew(textField: UITextField) {
        textField.isSecureTextEntry = true
        textField.placeholder = getString("user_password_new")
        self.textFieldNew = textField
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func initTextFieldConfirm(textField: UITextField) {
        textField.isSecureTextEntry = true
        textField.placeholder = getString("user_password_confirm")
        self.textFieldConfirm = textField
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        var isEnabled = false
        
        if textFieldNew?.text == textFieldConfirm?.text {
            isEnabled = Validate.isPasswordValid(password: textField.text)
        }
        
        setEnabledPositive(isEnabled: isEnabled)
    }
    
    override func btnPosAction() {
        if let passwordHandler = handler {
            passwordHandler(textFieldCurrent!.text!, textFieldNew!.text!)
        }
    }
    
}
