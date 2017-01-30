//
//  DialogElementTextField.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DialogElementTextField: UIView {
    
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
    
    private lazy var valueTextField: UITextField! = {
        let view = UITextField()
        view.setBottomBorder(Colors.colorAccent)
        view.textColor = Colors.colorAccent
        view.tintColor = Colors.colorAccent
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
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
}
