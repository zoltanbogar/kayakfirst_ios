//
//  BaseDialogelementTextField.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseDialogElementTextField<E: ViewDialogElementTextFieldLayout>: CustomUi<E>, UITextFieldDelegate {
    
    var title: String? {
        get {
            return contentLayout!.valueTextField.placeholder
        }
        
        set {
            contentLayout!.valueTextField.placeholder = newValue
        }
    }
    
    var keyBoardType: UIKeyboardType? {
        get {
            return contentLayout!.valueTextField.keyboardType
        }
        set {
            contentLayout!.valueTextField.keyboardType = newValue!
        }
    }
    
    var secureTextEntry: Bool {
        get {
            return contentLayout!.valueTextField.isSecureTextEntry
        }
        set {
            contentLayout!.valueTextField.isSecureTextEntry = newValue
        }
    }
    
    var error: String? {
        get {
            return contentLayout!.errorLabel.text
        }
        
        set {
            if let value = newValue {
                contentLayout!.errorLabel.isHidden = false
                contentLayout!.errorLabel.text = value
            } else {
                contentLayout!.errorLabel.isHidden = true
            }
        }
    }
    
    var required: Bool? {
        get {
            return false
        }
        set {
            if let titleText = title {
                title = titleText + " *"
            }
        }
    }
    
    var clickCallback: (() -> ())?
    private var _editable = true
    var isEditable: Bool {
        get {
            return _editable
        }
        set {
            _editable = newValue
        }
    }
    
    var text: String? {
        get {
            return contentLayout!.valueTextField.text
        }
        set {
            contentLayout!.valueTextField.text = newValue
            self.error = nil
        }
    }
    
    var active: Bool {
        get {
            return true
        }
        set {
            if newValue {
                contentLayout!.valueTextField.alpha = 1
            } else {
                contentLayout!.valueTextField.alpha = 0.5
            }
            isEditable = newValue
        }
    }
    var clickable: Bool = true
    var textChangedListener: (() -> ())?
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: 65)
        }
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.valueTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contentLayout!.valueTextField.delegate = self
    }
    
    @objc private func textFieldDidChange() {
        self.error = nil
        
        if let listener = textChangedListener {
            listener()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if clickable {
            if let click = clickCallback {
                click()
            }
        }
        return _editable
    }
    
}
