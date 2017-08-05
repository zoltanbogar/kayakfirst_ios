//
//  AppUiButton.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class AppUIButton: UIButton {
    
    //MARK: properties
    private var originalBackgroundColor: UIColor?
    private var textColor: UIColor?
    var text: String? {
        didSet {
            setTitle(text?.uppercased(), for: .normal)
        }
    }
    
    //MARK: init
    init(width: CGFloat, text: String, backgroundColor: UIColor, textColor: UIColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        self.textColor = textColor
        self.text = text
        self.originalBackgroundColor = backgroundColor
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    //MARK: init views
    private func initView() {
        layer.cornerRadius = 5
        backgroundColor = originalBackgroundColor
        setTitleColor(textColor, for: .normal)
        setTitleColor(Colors.colorInactive, for: .highlighted)
    }
    
    //MARK: functions
    func setDisabled(_ isDisabled: Bool) {
        if isDisabled {
            backgroundColor = Colors.colorInactive
        } else {
            backgroundColor = originalBackgroundColor
        }
        isEnabled = !isDisabled
    }
    
    //MARK: size
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: 50)
        }
    }
}
