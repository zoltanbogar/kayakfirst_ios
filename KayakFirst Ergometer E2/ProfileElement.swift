//
//  ProfileElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class ProfileElement: DialogElementTextField {
    
    //MARK: constants
    let textColorNormalValue = Colors.colorDashBoardDivider
    let textColorNormalTitle = Colors.colorWhite
    
    //MARK: properties
    override var title: String? {
        get {
            return labelTitle.text
        }
        
        set {
            labelTitle.text = newValue
        }
    }
    override var active: Bool {
        get {
            return true
        }
        set {
            if newValue {
                valueTextField.textColor = DialogElementTextField.colorHighlited
                labelTitle.textColor = DialogElementTextField.colorHighlited
            } else {
                valueTextField.textColor = textColorNormalValue
                labelTitle.textColor = textColorNormalTitle
            }
            isEditable = newValue
            error = nil
        }
    }
    
    //MARK: init view
    internal override func initView() {
        designValueTextField()
        
        backgroundColor = Colors.colorProfileElement
        
        addSubview(labelTitle)
        addSubview(valueTextField)
        addSubview(errorLabel)
        
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self).inset(UIEdgeInsetsMake(0, margin, 0, 0))
            make.right.equalTo(valueTextField.snp.left)
            make.centerY.equalTo(self)
        }
        
        valueTextField.snp.makeConstraints{ make in
            make.left.equalTo(labelTitle.snp.right)
            make.width.equalTo(labelTitle)
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, margin))
        }
        
        errorLabel.snp.makeConstraints { make in
            make.right.equalTo(valueTextField)
            make.top.equalTo(valueTextField.snp.bottom).offset(margin05)
            make.width.equalTo(self)
        }
    }
    
    func designValueTextField() {
        valueTextField.textAlignment = .right
        valueTextField.borderStyle = .none
        valueTextField.textColor = textColorNormalValue
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height:  profileElementHeight)
        }
    }
    
    //MARK: views
    internal lazy var labelTitle: AppUILabel! = {
        let label = AppUILabel()
        
        label.numberOfLines = 3
        
        return label
    }()
    
}
