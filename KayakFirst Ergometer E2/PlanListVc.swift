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

class PlanListVc: BaseVC<VcPlanListLayout> {
    
    //MARK: properties
    private let planManager = PlanManager.sharedInstance
    var planType: PlanType?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setPlanList()
    }
    
    //MARK: functions
    private func setPlanList() {
        search()
    }
    
    private func search() {
        let manager = planManager.getPlanByName(name: contentLayout!.etSearch.text, managerCallBack: planCallback)
        showProgress(baseManagerType: manager)
    }
    
    //MARK: callbacks
    private func planCallback(data: [Plan]?, error: Responses?) {
        dismissProgress()
        
        if data != nil {
            contentLayout?.tableViewPlan.dataList = data
        }
        
        errorHandlingWithToast(viewController: self, error: error)
    }
    
    private func deleteCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            setPlanList()
        }
        
        errorHandlingWithToast(viewController: self, error: error)
    }
    
    override func showProgress(baseManagerType: BaseManagerType?) {
        if let managerType = baseManagerType {
            let isShow = managerType.isProgressShown()
            
            showProgress(isShow: isShow)
        }
    }
    
    override func dismissProgress() {
        showProgress(isShow: false)
    }
    
    //TODO: sure?
    override func showProgress(isShow: Bool) {
        contentLayout?.progressBar.showProgressBar(isShow)
    }
    
    //MARK: initView
    override func initView() {
        super.initView()
        
        contentLayout?.btnAdd.target = self
        contentLayout?.btnAdd.action = #selector(addClick)
        contentLayout?.etSearch.searchListener = { text in
            self.search()
        }
        contentLayout?.tableViewPlan.deleteCallback = self.deleteCallback
        contentLayout?.tableViewPlan.rowClickCallback = { plan, position in
            startPlanDetailsViewController(viewController: self, plan: plan)
        }
        
        showLogoCenter(viewController: self)
        
        setPlanList()
    }
    
    override func getContentLayout(contentView: UIView) -> VcPlanListLayout {
        return VcPlanListLayout(contentView: contentView)
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems([contentLayout!.btnAdd], animated: true)
    }
    
    //MARK: clicklisteners
    @objc private func addClick() {
        startCreatePlanViewController(viewController: self, planType: planType!)
    }
}
