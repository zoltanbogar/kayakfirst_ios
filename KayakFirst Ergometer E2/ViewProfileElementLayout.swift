//
//  ViewProfileElementLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewProfileElementLayout: ViewDialogElementTextFieldLayout {
    
    override func setView() {
        designValueTextField()
        
        contentView.backgroundColor = Colors.colorProfileElement
        
        contentView.addSubview(labelTitle)
        contentView.addSubview(valueTextField)
        contentView.addSubview(errorLabel)
        
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin, 0, 0))
            make.right.equalTo(valueTextField.snp.left)
            make.centerY.equalTo(contentView)
        }
        
        valueTextField.snp.makeConstraints{ make in
            make.left.equalTo(labelTitle.snp.right)
            make.width.equalTo(labelTitle)
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 0, margin))
        }
        
        errorLabel.snp.makeConstraints { make in
            make.right.equalTo(valueTextField)
            make.top.equalTo(valueTextField.snp.bottom).offset(margin05)
            make.width.equalTo(contentView)
        }
    }
    
    func designValueTextField() {
        valueTextField.textAlignment = .right
        valueTextField.borderStyle = .none
    }
    
    //MARK: views
    internal lazy var labelTitle: AppUILabel! = {
        let label = AppUILabel()
        
        label.numberOfLines = 3
        
        return label
    }()
    
}
