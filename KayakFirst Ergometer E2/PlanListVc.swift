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
        let manager = planManager.getPlanByName(name: (contentLayout as! VcPlanListLayout).etSearch.text, managerCallBack: planCallback)
        showProgress(baseManagerType: manager)
    }
    
    //MARK: callbacks
    private func planCallback(data: [Plan]?, error: Responses?) {
        dismissProgress()
        
        if data != nil {
            (contentLayout as! VcPlanListLayout).tableViewPlan.dataList = data
        }
        
        errorHandlingWithAlert(viewController: self, error: error)
    }
    
    private func deleteCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            setPlanList()
        }
        
        errorHandlingWithAlert(viewController: self, error: error)
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
    
    private func showProgress(isShow: Bool) {
        if isShow {
            (contentLayout as! VcPlanListLayout).progressBar.startAnimating()
        } else {
            (contentLayout as! VcPlanListLayout).progressBar.stopAnimating()
        }
        
        (contentLayout as! VcPlanListLayout).progressBar.isHidden = !isShow
    }
    
    //MARK: initView
    override func initView() {
        super.initView()
        
        //TODO: move this to BaseVc
        self.contentLayout = getContentLayout(contentView: contentView)
        self.contentLayout?.setView()
        ///////////////////////////
        
        (contentLayout as! VcPlanListLayout).btnAdd.target = self
        (contentLayout as! VcPlanListLayout).btnAdd.action = #selector(addClick)
        (contentLayout as! VcPlanListLayout).etSearch.searchListener = { text in
            self.search()
        }
        (contentLayout as! VcPlanListLayout).tableViewPlan.deleteCallback = self.deleteCallback
        (contentLayout as! VcPlanListLayout).tableViewPlan.rowClickCallback = { plan, position in
            startPlanDetailsViewController(viewController: self, plan: plan)
        }
        
        showLogoCenter(viewController: self)
        
        setPlanList()
    }
    
    override func getContentLayout(contentView: UIView) -> VcPlanListLayout {
        return VcPlanListLayout(contentView: contentView)
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems([(contentLayout as! VcPlanListLayout).btnAdd], animated: true)
    }
    
    //MARK: clicklisteners
    @objc private func addClick() {
        startCreatePlanViewController(viewController: self, planType: planType!)
    }
}
