//
//  ProfileElementExpendable.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 31..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ProfileElementExpendable: ProfileElement, UITextViewDelegate {
    
    override var active: Bool {
        get {
            return true
        }
        set {
            if newValue {
                valueTextView.textColor = DialogElementTextField.colorHighlited
                labelTitle.textColor = DialogElementTextField.colorHighlited
            } else {
                valueTextView.textColor = textColorNormalValue
                labelTitle.textColor = textColorNormalTitle
            }
            isEditable = newValue
            error = nil
        }
    }
    
    override var keyBoardType: UIKeyboardType? {
        get {
            return valueTextView.keyboardType
        }
        set {
            valueTextView.keyboardType = newValue!
        }
    }
    
    override var text: String? {
        get {
            return valueTextView.text
        }
        set {
            valueTextView.text = newValue
            self.error = nil
            layoutIfNeeded()
        }
    }
    
    override func initView() {
        backgroundColor = Colors.colorProfileElement
        
        addSubview(labelTitle)
        addSubview(valueTextView)
        addSubview(errorLabel)
        
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self).inset(UIEdgeInsetsMake(0, margin, 0, 0))
            make.top.equalTo(self).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
        }
        
        valueTextView.snp.makeConstraints{ make in
            make.left.equalTo(self).inset(UIEdgeInsetsMake(0, margin, 0, 0))
            make.right.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, margin))
            make.top.equalTo(labelTitle.snp.bottom)
            make.bottom.equalTo(self)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.left.equalTo(valueTextView)
            make.top.equalTo(valueTextView.snp.bottom)
            make.width.equalTo(self)
        }
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height:  300)
        }
    }
    
    //MARK: views
    private lazy var valueTextView: UITextView! = {
        let view = UITextView()
        
        view.textColor = self.textColorNormalValue
        view.font = .systemFont(ofSize: 17)
        view.delegate = self
        
        return view
    }()
    
    //TODO: not correct yet
    func textViewDidChange(_ textView: UITextView) {
        var frame : CGRect = self.bounds
        frame.size.height = 50 + textView.contentSize.height
        self.bounds = frame
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if clickable {
            if let click = clickCallback {
                click()
            }
        }
        return isEditable
    }
}
