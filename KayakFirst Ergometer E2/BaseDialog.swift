//
//  BaseDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class BaseDialog {
    
    internal var alertController: UIAlertController?
    private var positiveAction: UIAlertAction?
    
    init(title: String?, message: String?) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    }
    
    func show() {
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController!, animated: true, completion: nil)
    }
    
    func dismiss() {
        alertController?.dismiss(animated: true, completion: nil)
    }
    
    internal func showPositiveButton(title: String) {
        positiveAction = UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: onPositiveButtonClicked)
        alertController?.addAction(positiveAction!)
    }
    
    internal func setEnabledPositive(isEnabled: Bool) {
        positiveAction?.isEnabled = isEnabled
    }
    
    internal func showNegativeButton(title: String) {
        alertController?.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: nil))
    }

    
    internal func onPositiveButtonClicked(uiAlertAction: UIAlertAction) {
        //nothing here
    }
    
}
