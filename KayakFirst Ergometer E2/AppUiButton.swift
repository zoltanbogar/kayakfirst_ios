//
//  AppUiButton.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class AppUIButton: UIButton {
    
    private var originalBackgroundColor: UIColor?
    private var text: String?
    private var textColor: UIColor?
    
    init(width: CGFloat, height: CGFloat, text: String, backgroundColor: UIColor, textColor: UIColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.textColor = textColor
        self.text = text
        self.originalBackgroundColor = backgroundColor
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        layer.cornerRadius = 5
        backgroundColor = originalBackgroundColor
        setTitleColor(textColor, for: .normal)
        setTitleColor(Colors.colorInactive, for: .highlighted)
        setTitle(text?.uppercased(), for: .normal)
    }
    
    func setDisabled(_ isDisabled: Bool) {
        if isDisabled {
            backgroundColor = Colors.colorInactive
        } else {
            backgroundColor = originalBackgroundColor
        }
        isEnabled = !isDisabled
    }
    
}
