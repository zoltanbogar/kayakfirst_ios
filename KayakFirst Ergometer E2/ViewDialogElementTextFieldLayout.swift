//
//  ViewDialogElementTextFieldLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewDialogElementTextFieldLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(valueTextField)
        contentView.addSubview(errorLabel)
        
        valueTextField.snp.makeConstraints{ make in
            make.width.equalTo(valueTextField.superview!)
            make.height.equalTo(40)
            make.center.equalTo(contentView)
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
        
        return view
    }()
    
    lazy var errorLabel: UILabel! = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.textAlignment = .right
        label.isHidden = true
        
        return label
    }()
    
}
