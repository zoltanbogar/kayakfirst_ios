//
//  PlanningTypeVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class PlanOrNotPlanVc: BaseVC, PlanTypeSelectListener {
    
    //MARK: button listeners
    @objc private func clickRun() {
        show(MainVc(), sender: self)
    }
    
    //MARK: protocol
    func timeSelected() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.time)
    }
    
    func distanceSelected() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.distance)
    }
    
    //MARK: initView
    override func initView() {
        super.initView()
        
        //TODO: move this to BaseVc
        self.contentLayout = getContentLayout(contentView: contentView)
        self.contentLayout?.setView()
        ///////////////////////////
        
        (contentLayout as! VcPlanOrNotPlanLayout).planTypeView.planTypeSelectListener = self
        (contentLayout as! VcPlanOrNotPlanLayout).viewRun.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickRun)))
        
        showLogoCenter(viewController: self)
    }
    
    override func getContentLayout(contentView: UIView) -> VcPlanOrNotPlanLayout {
        return VcPlanOrNotPlanLayout(contentView: contentView)
    }
}
