//
//  NewPasswordDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class NewPasswordDialog: BaseDialog {
    
    var textFieldCurrent: UITextField?
    var textFieldNew: UITextField?
    var textFieldConfirm: UITextField?
    
    init() {
        super.init(title: try! getString("user_password"), message: nil)
        
        showNegativeButton(title: try! getString("other_cancel"))
        showPositiveButton(title: try! getString("other_ok"))
        
        setEnabledPositive(isEnabled: false)
        
        alertController?.addTextField(configurationHandler: initTextFieldCurrent)
        alertController?.addTextField(configurationHandler: initTextFieldNew)
        alertController?.addTextField(configurationHandler: initTextFieldConfirm)
    }
    
    private func initTextFieldCurrent(textField: UITextField) {
        textField.isSecureTextEntry = true
        textField.placeholder = try! getString("user_password_old")
        self.textFieldCurrent = textField
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func initTextFieldNew(textField: UITextField) {
        textField.isSecureTextEntry = true
        textField.placeholder = try! getString("user_password_new")
        self.textFieldNew = textField
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func initTextFieldConfirm(textField: UITextField) {
        textField.isSecureTextEntry = true
        textField.placeholder = try! getString("user_password_confirm")
        self.textFieldConfirm = textField
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        var isEnabled = false
        
        if textFieldNew?.text == textFieldConfirm?.text {
            isEnabled = PasswordCheck.isPasswordValid(password: textField.text)
        }
        
        setEnabledPositive(isEnabled: isEnabled)
    }
    
    override func onPositiveButtonClicked(uiAlertAction: UIAlertAction) {
        //TODO
    }
    
}
