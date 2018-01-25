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
        
        //TODO: delete this
        SystemInfoDialog.showSystemInfoDialog()
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
    
    //MARK: button listeners
    @objc private func btnDoneClick() {
        let managerType = UserManager.sharedInstance.sendFeedback(managerCallback: { (data, error) in
            self.dismissProgress()
            
            if let error = error {
                errorHandlingWithAlert(viewController: self, error: error)
            }
        })
        showProgress(baseManagerType: managerType)
    }
    
    
}
