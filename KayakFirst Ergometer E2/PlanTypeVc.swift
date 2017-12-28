//
//  PlanTypeVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanTypeVc: BaseVC, PlanTypeSelectListener {
    
    //MARK: protocol
    func timeSelected() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.time)
    }
    
    func distanceSelected() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.distance)
    }
    
    //MARK: inint views
    override func initView() {
        super.initView()
        
        //TODO: move this to BaseVc
        self.contentLayout = getContentLayout(contentView: contentView)
        self.contentLayout?.setView()
        ///////////////////////////
        
        (contentLayout as! VcPlanTypeLayout).viewPlanType.planTypeSelectListener = self
    }
    
    override func getContentLayout(contentView: UIView) -> VcPlanTypeLayout {
        return VcPlanTypeLayout(contentView: contentView)
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
    }
    
}
