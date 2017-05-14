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
    
    //MARK: init view
    override func initView() {
        setEditLayout(isEdit: isEdit)
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
    }
    
    //MARK: views
    private lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "done_24dp")
        button.target = self
        button.action = #selector(btnSaveClick)
        
        return button
    }()
    
    private lazy var btnEdit: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "edit")
        button.target = self
        button.action = #selector(btnEditClick)
        
        return button
    }()
    
    //MARK: button listeners
    @objc private func btnSaveClick() {
        //TODO
    }
    
    @objc private func btnEditClick() {
        setEditLayout(isEdit: true)
    }
    
    //MARK: functions
    private func setEditLayout(isEdit: Bool) {
        if isEdit {
            setTabbarItem(tabbarItem: btnSave)
        } else {
            setTabbarItem(tabbarItem: btnSave)
        }
    }
    
    private func setTabbarItem(tabbarItem: UIBarButtonItem) {
        self.navigationItem.setRightBarButtonItems([tabbarItem], animated: true)
    }
    
    private func activateFields(isActive: Bool) {
        //TODO
    }
    
}
