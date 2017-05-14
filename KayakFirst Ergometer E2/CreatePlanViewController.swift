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
    private var snapShot: UIView?
    private var draggedView: UIView?
    private var indexPath: IndexPath?
    private var isDragEnded = true
    private var shouldDelete = false
    
    var activeTextView: UITextView?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [CreatePlanViewController.self]
    }
    
    //MARK: init view
    override func initView() {
        contentView.addSubview(planElementTableView)
        planElementTableView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.width.equalTo(100)
        }
        
        let stackViewDistance = UIStackView()
        stackViewDistance.axis = .horizontal
        stackViewDistance.spacing = 20
        stackViewDistance.distribution = .fillEqually
        
        stackViewDistance.addArrangedSubview(etDistance)
        stackViewDistance.addArrangedSubview(etIntensity)
        
        contentView.addSubview(stackViewDistance)
        stackViewDistance.snp.makeConstraints { (make) in
            make.left.equalTo(planElementTableView.snp.right).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(contentView).offset(20)
            make.height.equalTo(70)
        }
        
        contentView.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { (make) in
            make.top.equalTo(stackViewDistance.snp.bottom).offset(20)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.left.equalTo(stackViewDistance)
        }
        contentView.addSubview(imgDelete)
        imgDelete.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
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
    
    private lazy var planElementTableView: PlanElementTableView! = {
        let view = PlanElementTableView(view: self.contentView)
        
        view.dataList = Plan.getExamplePlans()[0].planElements
        
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPress)))
        
        return view
    }()
    
    private lazy var imgDelete: UIImageView! = {
        let view = UIImageView()
        
        view.image = UIImage(named: "ic_delete")
        
        view.isHidden = true
        
        return view
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
    
    //MARK: drag drop
    //MARK: listeners
    @objc private func onLongPress(gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: contentView)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            if isDragEnded {
                if self.snapShot == nil {
                    imgDelete.isHidden = false
                    
                    let tableLocation = gestureRecognizer.location(in: planElementTableView)
                    indexPath = planElementTableView.indexPathForRow(at: tableLocation)
                    draggedView = planElementTableView.cellForRow(at: indexPath!) as! UITableViewCell
                    
                    self.snapShot = draggedView!.getSnapshotView()
                    self.contentView.addSubview(self.snapShot!)
                    self.snapShot!.snp.makeConstraints { make in
                        make.center.equalTo(locationInView)
                    }
                    draggedView?.isHidden = true
                    //view.isSelected = true
                }
                isDragEnded = false
            }
        case UIGestureRecognizerState.changed:
            if let dragView = self.snapShot {
                dragView.center = locationInView
                
                shouldDelete = imgDelete.isDragDropEnter(superView: contentView, gestureRecognizer: gestureRecognizer)
            }
        default:
            self.snapShot?.removeFromSuperview()
            self.draggedView?.isHidden = false
            self.snapShot = nil
            self.draggedView = nil
            isDragEnded = true
            imgDelete.isHidden = true
            
            if shouldDelete {
                planElementTableView.deletePlanElement(position: (indexPath?.row)!)
            }
            shouldDelete = false
        }
    }
    
}
