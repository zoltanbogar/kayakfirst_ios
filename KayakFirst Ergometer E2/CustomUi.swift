//
//  CustomUi.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class CustomUi: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView(nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView(frame)
    }
    
    private func initView(_ frame: CGRect?) {
        //self.backgroundColor = getColor(Colors.colorTransparent)
        let view = UIView()
        self.addSubview(view)
        
        var viewFrame = frame
        
        if !checkFrame(frame: viewFrame) {
            viewFrame = view.superview?.bounds
        }
        
        view.frame = viewFrame!
        
        initUi(superview: view)
    }
    
    func initUi(superview: UIView) {
        //nothing here
    }
    
    internal func initConstraints(superView: UIView) {
        //nothing here
    }
    
    private func checkFrame(frame: CGRect?) -> Bool {
        if frame == nil {
            return false
        } else if frame?.width == 0 && frame?.height == 0 {
            return false
        } else {
            return true
        }
    }
    
}
