//
//  DesignUtils.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

func getRoundedButton(width: Int, image: UIImage, color: UIColor) -> UIButton {
    let button = UIButton()
    button.frame = CGRect(x: 0, y: 0, width: width, height: width)
    
    UIGraphicsBeginImageContextWithOptions(button.frame.size, false, image.scale)
    let rect = CGRect(x: 0, y: 0, width: button.frame.size.width, height: button.frame.size.height)
    UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2).addClip()
    image.draw(in: rect)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    button.layer.cornerRadius = 0.5 * button.bounds.size.width
    button.backgroundColor = color
    button.setImage(newImage, for: .normal)
    
    return button
}
