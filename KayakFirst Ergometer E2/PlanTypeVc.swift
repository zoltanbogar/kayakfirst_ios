//
//  PlanTypeVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func startPlanTypeVc(viewController: UIViewController) {
    viewController.show(PlanTypeVc(), sender: viewController)
}

class PlanTypeVc: BaseVC<VcPlanTypeLayout>, PlanTypeSelectListener {
    
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
        
        contentLayout?.viewPlanType.planTypeSelectListener = self
    }
    
    override func getContentLayout(contentView: UIView) -> VcPlanTypeLayout {
        return VcPlanTypeLayout(contentView: contentView)
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
    }
    
}
