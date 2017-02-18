//
//  UITextField+.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit
import SnapKit

extension UITextField {
    func setBottomBorder(_ borderColor: UIColor) {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 1.0
        
        let borderLine = UIView()
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
        
        borderLine.snp.makeConstraints{ make in
            make.width.equalTo(borderLine.superview!)
            make.height.equalTo(width)
            make.bottom.equalTo((borderLine.superview?.snp.bottom)!)
            make.left.equalTo((borderLine.superview?.snp.left)!)
        }
    }
    func removeBorderLine() {
        removeAllSubviews()
    }
}
