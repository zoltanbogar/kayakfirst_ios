//
//  PlanDetailsViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

func startPlanDetailsViewController(viewController: UIViewController, plan: Plan) {
    startPlanDetailsViewController(viewController: viewController, plan: plan, isEdit: false)
}

func finishEditPlanDetailsVc(viewController: UIViewController, plan: Plan) {
    viewController.dismiss(animated: true, completion: nil)
    
    PlanDetailsViewController.plan = plan
}

func startPlanDetailsViewController(viewController: UIViewController, plan: Plan, isEdit: Bool) {
    let planDetailsVC = PlanDetailsViewController()
    PlanDetailsViewController.plan = plan
    planDetailsVC.isEdit = isEdit
    planDetailsVC.parentVc = viewController
    
    let navVc = PortraitNavController()
    navVc.pushViewController(planDetailsVC, animated: false)
    viewController.present(navVc, animated: true, completion: nil)
}

class PlanDetailsViewController: BaseVC {
    
    //MARK: properties
    static var plan: Plan?
    var isEdit: Bool = false
    var parentVc: UIViewController?
    
    private var planManager = PlanManager.sharedInstance
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setPlanToTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        initPlanFromAdapter()
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
        DeletePlanDialog.showDeletePlanDialog(viewController: self, plan: PlanDetailsViewController.plan!, managerCallback: deletePlanCallback)
    }
    
    @objc private func btnEditClick() {
        setEditLayout(isEdit: true)
    }
    
    func eventSaved() {
        showPlanListVc()
    }
    
    private func showPlanListVc() {
        setEditLayout(isEdit: false)
        
        initPlanFromAdapter()
        
        if PlanDetailsViewController.plan != nil {
            let manager = planManager.savePlan(plan: PlanDetailsViewController.plan!, managerCallBack: planCallback)
            showProgress(baseManagerType: manager)
        }
        
        if self.parentVc != nil && self.parentVc! is CreatePlanViewController {
            
            self.dismiss(animated: true, completion: {
                log("NAV_TEST", "self.parent is CreatePlanViewController")
                
                (self.parentVc! as! CreatePlanViewController).dismiss(animated: false, completion: nil)
            })
            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func showEventDetailsVc() {
        initPlanFromAdapter()
        if let planValue = PlanDetailsViewController.plan {
            startEventDetailsViewController(viewController: self, plan: planValue)
        }
    }
    
    //MARK: functions
    private func setEditLayout(isEdit: Bool) {
        planDetailsTableView.setEdit(edit: isEdit, editShouldFinish: self.isEdit)
        if isEdit {
            setTabbarItem(tabbarItems: [btnSave, btnDelete])
        } else {
            setTabbarItem(tabbarItems: [btnEdit])
        }
    }
    
    private func setTabbarItem(tabbarItems: [UIBarButtonItem]) {
        self.navigationItem.setRightBarButtonItems(tabbarItems, animated: true)
    }
    
    private func initPlanFromAdapter() {
        PlanDetailsViewController.plan = planDetailsTableView.plan
    }
    
    private func setPlanToTableView() {
        planDetailsTableView.plan = PlanDetailsViewController.plan
    }
    
    //MARK: plan callbacks
    private func planCallback(data: Bool?, error: Responses?) {
        dismissProgress()
        
        errorHandlingWithAlert(viewController: self, error: error)
    }
    
    private func deletePlanCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            dismiss(animated: true, completion: nil)
        }
        errorHandlingWithAlert(viewController: self, error: error)
    }
    
}
