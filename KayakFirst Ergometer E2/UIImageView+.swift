//
//  UIImageView+.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageTint(color: UIColor) {
        if image != nil {
            image = image!.withRenderingMode(.alwaysTemplate)
            tintColor = color
        }
    }
    
}
