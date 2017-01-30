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
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(valueTextField)
        
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
    }
    
    lazy var titleLabel: UILabel! = {
        let view = AppUILabel()
        return view
    }()
    
    lazy var valueTextField: UITextField! = {
        let view = UITextField()
        view.setBottomBorder(Colors.colorAccent)
        view.textColor = Colors.colorAccent
        
        return view
    }()
}
