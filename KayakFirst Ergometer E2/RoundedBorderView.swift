//
//  RoundedBorderView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class RoundedBorderView: UIView {
    
    //MARK: properties
    private var border: CAShapeLayer? = nil
    
    var cornerRadius: CGFloat = dashboardRadius {
        didSet {
            initView()
        }
    }
    
    var borderColor: UIColor = Colors.colorWhite {
        didSet {
            initView()
        }
    }
    
    var borderWidth: CGFloat = dashboardSetStrokeWidth {
        didSet {
            initView()
        }
    }
    
    var isDashed: Bool = false {
        didSet {
            initView()
        }
    }
    
    override func layoutSubviews() {
        initView()
    }
    
    //MARK: view
    private func initView() {
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        if (border == nil) {
            border = CAShapeLayer()
            self.layer.addSublayer(border!)
        }
        
        border!.frame = bounds
        let pathUsingCorrectInsetIfAny = UIBezierPath(roundedRect: border!.bounds, cornerRadius: cornerRadius)
        
        border!.path = pathUsingCorrectInsetIfAny.cgPath
        border!.fillColor = UIColor.clear.cgColor
        
        border!.strokeColor = borderColor.cgColor
        border!.lineWidth = borderWidth * 2.0
        
        if isDashed {
            border?.lineDashPattern = NSArray(array: [NSNumber(value: 4), NSNumber(value: 4)]) as? [NSNumber]
        }
    }
    
}
