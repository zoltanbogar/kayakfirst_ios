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
        setEditLayout(isEdit: false)
        //TODO: save
    }
    
    @objc private func btnDeleteClick() {
        //TODO
    }
    
    @objc private func btnEditClick() {
        setEditLayout(isEdit: true)
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
    
}
