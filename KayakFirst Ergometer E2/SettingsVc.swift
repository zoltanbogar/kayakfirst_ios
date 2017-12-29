//
//  SettingsVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class SettingsVc: BaseVC<VcSettingsLayout>, UITextFieldDelegate {
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTitle()
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.textFieldWebsite.delegate = self
        contentLayout!.textFieldTermsCondition.delegate = self
    }
    
    override func getContentLayout(contentView: UIView) -> VcSettingsLayout {
        return VcSettingsLayout(contentView: contentView)
    }
    
    private func initTitle() {
        title = getString("navigation_settings")
    }
    
    //MARK: callbacks
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == contentLayout!.textFieldTermsCondition {
            UIApplication.shared.openURL(NSURL(string: "http://kayakfirst.com/terms-conditions")! as URL)
            return false
        } else if textField == contentLayout!.textFieldWebsite {
            UIApplication.shared.openURL(NSURL(string: "http://kayakfirst.com")! as URL)
            return false
        } else {
            return true
        }
    }
    
}
