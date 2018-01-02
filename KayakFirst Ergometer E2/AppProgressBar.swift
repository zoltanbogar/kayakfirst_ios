//
//  AppProgressBar.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class AppProgressBar: UIActivityIndicatorView {
    
    //MARK: init
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: buttonHeight, height: buttonHeight))
        
        activityIndicatorViewStyle = .whiteLarge
        color = Colors.colorAccent
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: functions
    func showProgressBar(_ isShow: Bool) {
        if isShow {
            startAnimating()
        } else {
            stopAnimating()
        }
        
        isHidden = !isShow
    }
}
