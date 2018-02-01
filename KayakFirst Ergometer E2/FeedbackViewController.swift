//
//  FeedbackViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 22..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func showFeedbackVc(viewController: UIViewController) {
    let feedbackVc = FeedbackViewController()
    let navController = PortraitNavController()
    navController.pushViewController(feedbackVc, animated: false)
    viewController.present(navController, animated: true, completion: nil)
}

class FeedbackViewController: BaseVC<VcFeedbackLayout> {
    
    //MARK: view
    override func initView() {
        super.initView()
        
        contentLayout?.btnDone.target = self
        contentLayout?.btnDone.action = #selector(btnDoneClick)
        
        linkText()
    }
    
    override func getContentLayout(contentView: UIView) -> VcFeedbackLayout {
        return VcFeedbackLayout(contentView: contentView)
    }
    
    override func initTabBarItems() {
        if contentLayout != nil {
            let buttons: [UIBarButtonItem] = [contentLayout!.btnDone]
            
            self.navigationItem.setRightBarButtonItems(buttons, animated: true)
            
            showCloseButton()
            
            showLogoCenter(viewController: self)
        }
    }
    
    //MARK: functions
    private func linkText() {
        let textInfo = getString("feedback_info_text") + " "
        let textInfoHelper = LinkHelper(clickListener: nil, text: textInfo, color: UIColor.black)
        
        let textSystemInfo = getString("feedback_info_logs")
        let systemInfoHelper = LinkHelper(clickListener: {
            SystemInfoDialog.showSystemInfoDialog()
        }, text: textSystemInfo, color: Colors.colorAccent)
        
        let dotHelper = LinkHelper(clickListener: nil, text: ".", color: UIColor.black)
        
        let linkHelpers = [textInfoHelper, systemInfoHelper, dotHelper]
        
        
        AppLinkHelper.linkText(activeLabel: contentLayout!.labelInfo, linkHelpers: linkHelpers)
    }
    
    //MARK: button listeners
    @objc private func btnDoneClick() {
        let message = contentLayout!.tvFeedback.text ?? ""
        
        let managerType = LogManager.sharedInstance.sendFeedback(managerCallback: { (data, error) in
            self.dismissProgress()
            
            if let error = error {
                errorHandlingWithAlert(viewController: self, error: error)
            }
        }, message: message)
        showProgress(baseManagerType: managerType)
    }
    
    
}
