//
//  CreatePlanViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

func startCreatePlanViewController(viewController: UIViewController, planType: PlanType) {
    let navigationVc = UINavigationController()
    let createPlanVc = CreatePlanViewController()
    createPlanVc.planType = planType
    navigationVc.pushViewController(createPlanVc, animated: false)
    viewController.present(navigationVc, animated: true, completion: nil)
}

class CreatePlanViewController: BaseVC, UITextViewDelegate, OnKeyboardClickedListener {
    //MARK: properties
    var planType: PlanType?
    
    var activeTextView: UITextView?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [CreatePlanViewController.self]
    }
    
    //MARK: init view
    override func initView() {
        let stackViewDistance = UIStackView()
        stackViewDistance.axis = .horizontal
        stackViewDistance.spacing = 20
        stackViewDistance.distribution = .fillEqually
        
        stackViewDistance.addArrangedSubview(etDistance)
        stackViewDistance.addArrangedSubview(etIntensity)
        
        contentView.addSubview(stackViewDistance)
        stackViewDistance.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(contentView).offset(20)
            make.height.equalTo(70)
        }
        
        contentView.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { (make) in
            make.top.equalTo(stackViewDistance.snp.bottom).offset(20)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.left.equalTo(contentView)
        }
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
        self.navigationItem.setRightBarButtonItems([btnSave], animated: true)
    }
    
    //MARK: views
    private lazy var keyboardView: KeyboardNumView! = {
        let keyboardView = KeyboardNumView()
        
        keyboardView.createPlanViewController = self
        
        return keyboardView
    }()
    
    private lazy var etIntensity: NoImeEditText! = {
        let et = NoImeEditText()
        
        et.delegate = self
        
        return et
    }()
    
    private lazy var etDistance: NoImeEditText! = {
        let et = NoImeEditText()
        
        et.delegate = self
        
        return et
    }()
    
    //MARK: tabbarItems
    private lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.title = getString("other_save")
        button.target = self
        button.action = #selector(btnSaveClick)
        
        return button
    }()
    
    //MARK: button listeners
    @objc func btnSaveClick() {
        //TODO
    }
    
    //MARK: textView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func onClicked(value: Int) {
        if value == KeyboardNumView.valueNext {
            //TODO
        }
    }
    
    
}
