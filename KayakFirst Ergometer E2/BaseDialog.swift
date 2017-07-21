//
//  BaseDialog.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 12..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class BaseDialog {
    
    //MARK: properties
    internal var alertController: UIAlertController?
    private var positiveAction: UIAlertAction?
    
    var noticeDialogPosListener: (() -> ())?
    var noticeDialogNegListener: (() -> ())?
    
    //MARK: init
    init(title: String?, message: String?) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    }
    
    //MARK: functions
    func show() {
        UIApplication.shared.keyWindow?.currentViewController()?.present(alertController!, animated: true, completion: nil)
    }
    
    func show(viewController: UIViewController) {
        viewController.present(alertController!, animated: true, completion: nil)
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
        alertController?.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: onNegativeButtonClicked))
    }

    //MARK: protocol
    private func onPositiveButtonClicked(uiAlertAction: UIAlertAction) {
        btnPosAction()
        
        if let listener = noticeDialogPosListener {
            listener()
        }
    }
    
    private func onNegativeButtonClicked(uiAlertAction: UIAlertAction) {
        btnNegAction()
        
        if let listener = noticeDialogNegListener {
            listener()
        }
    }
    
    internal func btnPosAction() {
        //override if needed
    }
    
    internal func btnNegAction() {
        //override if needed
    }
}
