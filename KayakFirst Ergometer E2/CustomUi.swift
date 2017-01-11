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
        let view = UIView()
        self.addSubview(view)
        
        let viewFrame = frame != nil ? frame : (view.superview?.bounds)!
        
        view.frame = viewFrame!
        
        initUi(superview: view)
    }
    
    func initUi(superview: UIView) {
        //nothing here
    }
    
    internal func initConstraints(superView: UIView) {
        //nothing here
    }
    
}
