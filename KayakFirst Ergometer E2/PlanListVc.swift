//
//  PlanListVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func startPlanListVc(navigationController: UINavigationController, planType: PlanType) {
    let planListVc = PlanListVc()
    planListVc.planType = planType
    
    navigationController.pushViewController(planListVc, animated: true)
}

class PlanListVc: BaseVC {
    
    //MARK: properties
    var planType: PlanType?
    
    //MARK: functions
    private func setPlanList() {
        tableViewPlan.dataList = Plan.getExamplePlans()
    }
    
    //MARK: initView
    override func initView() {
        showLogoCenter(viewController: self)
        
        self.contentView.addSubview(tableViewPlan)
        tableViewPlan.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.width.equalTo(200)
            make.center.equalTo(self.contentView)
            //make.edges.equalTo(self.contentView)
        }
        
        setPlanList()
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems([btnAdd], animated: true)
    }
    
    //MARK: views
    private lazy var btnAdd: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_add_white")
        button.target = self
        button.action = #selector(addClick)
        
        return button
    }()

    private lazy var tableViewPlan: PlanTableView! = {
        let tableViewPlan = PlanTableView(view: self.contentView)
        
        tableViewPlan.rowClickCallback = { plan, position in
            //TODO
        }
        
        return tableViewPlan
    }()
    
    //MARK: clicklisteners
    @objc private func addClick() {
        //TODO
    }
}
