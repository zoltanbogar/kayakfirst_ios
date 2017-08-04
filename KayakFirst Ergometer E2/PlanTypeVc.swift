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
        contentView.addSubview(viewPlanType)
        viewPlanType.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
    }
    
    //MARK: views
    private lazy var viewPlanType: PlanTypeView! = {
        let view = PlanTypeView()
        
        view.planTypeSelectListener = self
        
        return view
    }()
}
