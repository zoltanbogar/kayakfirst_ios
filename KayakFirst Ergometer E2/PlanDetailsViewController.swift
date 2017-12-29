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

class PlanDetailsViewController: BaseVC<VcPlanDetailsLayout> {
    
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
        super.initView()
        
        setEditLayout(isEdit: isEdit)
        
        contentLayout?.btnSave.target = self
        contentLayout?.btnSave.action = #selector(btnSaveClick)
        contentLayout?.btnDelete.target = self
        contentLayout?.btnDelete.action = #selector(btnDeleteClick)
        contentLayout?.btnEdit.target = self
        contentLayout?.btnEdit.action = #selector(btnEditClick)
    }
    
    override func getContentLayout(contentView: UIView) -> VcPlanDetailsLayout {
        return VcPlanDetailsLayout(contentView: contentView)
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
    }
    
    //MARK: button listeners
    @objc private func btnSaveClick() {
        let isValidPlanName = contentLayout!.planDetailsTableView.isNameValid
        
        if (!isValidPlanName) {
            contentLayout?.planDetailsTableView.scrollToPosition(position: 0)
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
    }
    
    private func showEventDetailsVc() {
        initPlanFromAdapter()
        if let planValue = PlanDetailsViewController.plan {
            startEventDetailsViewController(viewController: self, plan: planValue)
        }
    }
    
    //MARK: functions
    func setEditLayout(isEdit: Bool) {
        contentLayout?.planDetailsTableView.setEdit(edit: isEdit, editShouldFinish: self.isEdit)
        if isEdit {
            setTabbarItem(tabbarItems: [contentLayout!.btnSave, contentLayout!.btnDelete])
        } else {
            setTabbarItem(tabbarItems: [contentLayout!.btnEdit])
        }
    }
    
    private func setTabbarItem(tabbarItems: [UIBarButtonItem]) {
        self.navigationItem.setRightBarButtonItems(tabbarItems, animated: true)
    }
    
    private func initPlanFromAdapter() {
        PlanDetailsViewController.plan = contentLayout?.planDetailsTableView.plan
    }
    
    private func setPlanToTableView() {
        contentLayout?.planDetailsTableView.plan = PlanDetailsViewController.plan
    }
    
    //MARK: plan callbacks
    private func planCallback(data: Bool?, error: Responses?) {
        dismissProgress()
        
        errorHandlingWithAlert(viewController: self, error: error)
        
        if self.parentVc != nil && self.parentVc! is CreatePlanViewController {
            
            self.dismiss(animated: true, completion: {
                (self.parentVc! as! CreatePlanViewController).dismiss(animated: false, completion: nil)
            })
            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func deletePlanCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            dismiss(animated: true, completion: nil)
        }
        errorHandlingWithAlert(viewController: self, error: error)
    }
    
}
