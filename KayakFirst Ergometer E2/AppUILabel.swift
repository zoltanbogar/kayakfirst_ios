//
//  AppUILabel.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class AppUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTextColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTextColor()
    }
    
    private func setTextColor() {
        textColor = Colors.colorWhite
    }
    
}
