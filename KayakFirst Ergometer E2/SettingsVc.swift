//
//  SettingsVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 16..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class SettingsVc: MainTabVc, UITextFieldDelegate {
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTitle()
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        //TODO: move this to BaseVc
        self.contentLayout = getContentLayout(contentView: contentView)
        self.contentLayout?.setView()
        ///////////////////////////
        
        (contentLayout as! VcSettingsLayout).textFieldWebsite.delegate = self
        (contentLayout as! VcSettingsLayout).textFieldTermsCondition.delegate = self
    }
    
    override func getContentLayout(contentView: UIView) -> VcSettingsLayout {
        return VcSettingsLayout(contentView: contentView)
    }
    
    private func initTitle() {
        title = getString("navigation_settings")
    }
    
    //MARK: callbacks
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == (contentLayout as! VcSettingsLayout).textFieldTermsCondition {
            UIApplication.shared.openURL(NSURL(string: "http://kayakfirst.com/terms-conditions")! as URL)
            return false
        } else if textField == (contentLayout as! VcSettingsLayout).textFieldWebsite {
            UIApplication.shared.openURL(NSURL(string: "http://kayakfirst.com")! as URL)
            return false
        } else {
            return true
        }
    }
    
}
