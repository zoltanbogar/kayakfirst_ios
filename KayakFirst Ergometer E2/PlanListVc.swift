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
        let manager = planManager.getPlanByName(name: etSearch.text, managerCallBack: planCallback)
        showProgress(baseManagerType: manager)
    }
    
    //MARK: callbacks
    private func planCallback(data: [Plan]?, error: Responses?) {
        dismissProgress()
        
        tableViewPlan.dataList = data
    }
    
    private func deleteCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            setPlanList()
        }
    }
    
    //MARK: initView
    override func initView() {
        showLogoCenter(viewController: self)
        
        contentView.addSubview(etSearch)
        etSearch.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(margin2)
            make.right.equalTo(contentView).offset(-margin2)
            make.top.equalTo(contentView).offset(margin)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(tableViewPlan)
        tableViewPlan.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.top.equalTo(etSearch.snp.bottom).offset(margin)
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
        let tableViewPlan = PlanTableView(view: self.contentView, deleteCallback: self.deleteCallback)
        
        tableViewPlan.rowClickCallback = { plan, position in
            startPlanDetailsViewController(viewController: self, plan: plan)
        }
        
        return tableViewPlan
    }()
    
    private lazy var etSearch: SearchTextView! = {
        let view = SearchTextView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.white
        
        view.searchListener = { text in
            self.search()
        }
        
        return view
    }()
    
    //MARK: clicklisteners
    @objc private func addClick() {
        startCreatePlanViewController(viewController: self, planType: planType!)
    }
}
