//
//  DialogElementTextField.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DialogElementTextField: UIView, UITextFieldDelegate {
    
    private static let colorNormal = Colors.colorWhite
    private static let colorHighlited = Colors.colorAccent
    
    var title: String? {
        get {
            return titleLabel.text
        }
        
        set {
            titleLabel.text = newValue
        }
    }
    
    var keyBoardType: UIKeyboardType? {
        get {
            return valueTextField.keyboardType
        }
        set {
            valueTextField.keyboardType = newValue!
        }
    }
    
    var secureTextEntry: Bool {
        get {
            return valueTextField.isSecureTextEntry
        }
        set {
            valueTextField.isSecureTextEntry = newValue
        }
    }
    
    var error: String? {
        get {
            return errorLabel.text
        }
        
        set {
            if let value = newValue {
                errorLabel.isHidden = false
                errorLabel.text = value
            } else {
                errorLabel.isHidden = true
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
            return valueTextField.text
        }
        set {
            valueTextField.text = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(valueTextField)
        addSubview(errorLabel)
        
        titleLabel.snp.makeConstraints{ make in
            make.left.equalTo(titleLabel.superview!)
            make.top.equalTo(titleLabel.superview!)
            make.width.equalTo(titleLabel.superview!)
        }
        
        valueTextField.snp.makeConstraints{ make in
            make.left.equalTo(valueTextField.superview!)
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.equalTo(valueTextField.superview!)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.left.equalTo(errorLabel.superview!)
            make.top.equalTo(valueTextField.snp.bottom)
            make.width.equalTo(errorLabel.superview!)
        }
    }
    
    private lazy var titleLabel: UILabel! = {
        let view = AppUILabel()
        return view
    }()
    
    lazy var valueTextField: UITextField! = {
        let view = UITextField()
        view.setBottomBorder(colorNormal)
        view.textColor = Colors.colorAccent
        view.tintColor = Colors.colorAccent
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.delegate = self
        
        return view
    }()
    
    private lazy var errorLabel: UILabel! = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.textAlignment = .right
        label.isHidden = true
        
        return label
    }()
    
    @objc private func textFieldDidChange() {
        self.error = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        valueTextField.setBottomBorder(DialogElementTextField.colorHighlited)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        valueTextField.setBottomBorder(DialogElementTextField.colorNormal)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let click = clickCallback {
            click()
        }
        return _editable
    }
}
