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
    static let colorHighlited = Colors.colorAccent
    
    var title: String? {
        get {
            return valueTextField.placeholder
        }
        
        set {
            valueTextField.placeholder = newValue
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
            self.error = nil
        }
    }
    
    var active: Bool {
        get {
            return true
        }
        set {
            if newValue {
                valueTextField.alpha = 1
            } else {
                valueTextField.alpha = 0.5
            }
            isEditable = newValue
        }
    }
    var clickable: Bool = true
    var textChangedListener: (() -> ())?
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: 65)
        }
    }
    
    //MARK: init view
    func initView() {
        addSubview(valueTextField)
        addSubview(errorLabel)
        
        valueTextField.snp.makeConstraints{ make in
            make.width.equalTo(valueTextField.superview!)
            make.height.equalTo(40)
            make.center.equalTo(self)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.left.equalTo(valueTextField)
            make.top.equalTo(valueTextField.snp.bottom)
            make.width.equalTo(errorLabel.superview!)
        }
    }
    
    //MARK: views
    lazy var valueTextField: UITextField! = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.textColor = Colors.colorAccent
        view.tintColor = Colors.colorAccent
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.delegate = self
        
        return view
    }()
    
    lazy var errorLabel: UILabel! = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.textAlignment = .right
        label.isHidden = true
        
        return label
    }()
    
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
