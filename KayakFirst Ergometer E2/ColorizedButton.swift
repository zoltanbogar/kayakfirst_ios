//
//  ColorizedButton.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ColorizedButton: UIButton {
    
    var pressedBackgroundColor: UIColor = Colors.colorKeyPressed
    
    private var originalBackgroundColor: UIColor?
    
    override open var isHighlighted: Bool {
        didSet {
            if originalBackgroundColor == nil {
                originalBackgroundColor = backgroundColor
            }
            backgroundColor = isHighlighted ? pressedBackgroundColor : originalBackgroundColor
        }
    }
}
