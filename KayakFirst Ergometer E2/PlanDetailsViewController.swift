//
//  PlanDetailsViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func startPlanDetailsViewController(viewController: UIViewController, plan: Plan, isEdit: Bool) {
    let planDetailsVC = PlanDetailsViewController()
    planDetailsVC.plan = plan
    planDetailsVC.isEdit = isEdit
    
    let navVc = UINavigationController()
    navVc.pushViewController(planDetailsVC, animated: false)
    viewController.present(navVc, animated: true, completion: nil)
}

class PlanDetailsViewController: BaseVC {
    
    //MARK: properties
    var plan: Plan?
    var isEdit: Bool = false
    
    private var planManager = PlanManager.sharedInstance
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    //MARK: init view
    override func initView() {
        setEditLayout(isEdit: isEdit)
        
        contentView.addSubview(planDetailsTableView)
        planDetailsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
    }
    
    //MARK: views
    private lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "save")
        button.target = self
        button.action = #selector(btnSaveClick)
        
        return button
    }()
    
    private lazy var btnDelete: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "trash")
        button.target = self
        button.action = #selector(btnDeleteClick)
        
        return button
    }()
    
    private lazy var btnEdit: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "edit")
        button.target = self
        button.action = #selector(btnEditClick)
        
        return button
    }()
    
    private lazy var planDetailsTableView: PlanDetailsTableView! = {
        let view = PlanDetailsTableView(view: self.contentView)
        
        view.plan = self.plan
        
        return view
    }()
    
    //MARK: button listeners
    @objc private func btnSaveClick() {
        let isValidPlanName = planDetailsTableView.isNameValid
        
        if (!isValidPlanName) {
            planDetailsTableView.scrollToPosition(position: 0)
        } else {
            let addEventDialog = AddEventDialog()
            addEventDialog.noticeDialogPosListener = {
                self.showEventDetailsVc()
            }
            addEventDialog.noticeDialogNegListener = {
                self.showPlanListVc()
            }
            addEventDialog.show(viewController: self)
        }
    }
    
    @objc private func btnDeleteClick() {
        DeletePlanDialog.showDeletePlanDialog(viewController: self, plan: plan!, managerCallback: deletePlanCallback)
    }
    
    @objc private func btnEditClick() {
        setEditLayout(isEdit: true)
    }
    
    private func showPlanListVc() {
        setEditLayout(isEdit: false)
        
        initPlanFromAdapter()
        
        if plan != nil {
            let manager = planManager.savePlan(plan: plan!, managerCallBack: planCallback)
            showProgress(baseManagerType: manager)
        }
        
        //TODO: finish and etc.
    }
    
    private func showEventDetailsVc() {
        initPlanFromAdapter()
        if let planValue = plan {
            startEventDetailsViewController(viewController: self, plan: planValue)
        }
    }
    
    //MARK: functions
    private func setEditLayout(isEdit: Bool) {
        planDetailsTableView.isEdit = isEdit
        if isEdit {
            setTabbarItem(tabbarItems: [btnSave, btnDelete])
        } else {
            setTabbarItem(tabbarItems: [btnEdit])
        }
    }
    
    private func setTabbarItem(tabbarItems: [UIBarButtonItem]) {
        self.navigationItem.setRightBarButtonItems(tabbarItems, animated: true)
    }
    
    private func activateFields(isActive: Bool) {
        planDetailsTableView.isEdit = isActive
        //TODO
    }
    
    private func initPlanFromAdapter() {
        plan = planDetailsTableView.plan
    }
    
    //MARK: plan callbacks
    private func planCallback(data: Bool?, error: Responses?) {
        dismissProgress()
    }
    
    private func deletePlanCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
