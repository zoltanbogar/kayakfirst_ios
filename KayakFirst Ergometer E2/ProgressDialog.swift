//
//  ProgressDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class ProgressDialog: BaseDialog {
    
    private let messageString = "\n\n\n"
    
    init(title: String?) {
        super.init(title: title, message: messageString)
        
        initSpinner()
    }
    
    private func initSpinner() {
        let spinnerIndicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController?.view.addSubview(spinnerIndicator)
    }
    
}
