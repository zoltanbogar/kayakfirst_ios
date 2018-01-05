//
//  CreatePlanViewController.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

func startCreatePlanViewController(viewController: UIViewController, plan: Plan) {
    let navigationVc = PortraitNavController()
    let createPlanVc = CreatePlanViewController()
    createPlanVc.plan = plan
    
    navigationVc.pushViewController(createPlanVc, animated: false)
    viewController.present(navigationVc, animated: true, completion: nil)
}

func startCreatePlanViewController(viewController: UIViewController, planType: PlanType) {
    let navigationVc = PortraitNavController()
    let createPlanVc = CreatePlanViewController()
    createPlanVc.planType = planType
    
    navigationVc.pushViewController(createPlanVc, animated: false)
    viewController.present(navigationVc, animated: true, completion: nil)
}

class CreatePlanViewController: BaseVC<VcCreatePlanLayout>, OnFocusedListener, OnKeyboardClickedListener, OnTextChangedListener, DragDropPlanHelperDelegate {
    
    //MARK: properties
    var plan: Plan?
    var planType: PlanType?
    
    private var isEdit = false
    
    static var staticName: String?
    static var staticNotes: String?
    
    private var dragDropHelper: DragDropPlanHelper?
    
    var activeTextView: UITextView?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [CreatePlanViewController.self]
        automaticallyAdjustsScrollViewInsets = false
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        setUiForType()
        
        contentLayout?.keyboardView.createPlanViewController = self
        contentLayout?.keyboardView.keyboardClickListener = self
        
        contentLayout?.etMinute.onFocusedListener = self
        contentLayout?.etMinute.onTextChangedListener = self
        contentLayout?.etSec.onFocusedListener = self
        contentLayout?.etSec.onTextChangedListener = self
        contentLayout?.etIntensity.onFocusedListener = self
        contentLayout?.etIntensity.onTextChangedListener = self
        contentLayout?.etDistance.onFocusedListener = self
        contentLayout?.etDistance.onTextChangedListener = self
        
        addDragDrop()
        
        contentLayout?.btnSave.target = self
        contentLayout?.btnSave.action = #selector(btnSaveClick)
        contentLayout?.btnPlay.target = self
        contentLayout?.btnPlay.action = #selector(clickPlay)
    }
    
    override func getContentLayout(contentView: UIView) -> VcCreatePlanLayout {
        return VcCreatePlanLayout(contentView: contentView)
    }
    
    private func setUiForType() {
        if planType == nil {
            planType = plan!.type
        }
        
        contentLayout?.setUIForType(planType: planType!)
        
        if plan == nil {
            plan = Plan(type: planType!)
        } else {
            isEdit = true
        }
        
        contentLayout?.planElementTableView.type = plan?.type
        contentLayout?.planElementTableView.addPlanElementsAll(planElements: plan?.planElements)
    }
    
    private func addDragDrop() {
        dragDropHelper = DragDropPlanHelper(contentLayout: contentLayout!, contentView: contentView)
        dragDropHelper!.delegate = self
        dragDropHelper!.activate(gestureRecognizer: UILongPressGestureRecognizer(target: self, action: #selector(onLongPress)))
    }
    
    @objc private func onLongPress(gestureRecognizer: UIGestureRecognizer) {
        dragDropHelper?.onLongPress(gestureRecognizer: gestureRecognizer)
    }
    
    func shouldDelete(position: Int) {
        contentLayout!.planElementTableView.deletePlanElement(position: position)
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
        self.navigationItem.setRightBarButtonItems([contentLayout!.btnSave, contentLayout!.btnPlay], animated: true)
    }
    
    //MARK: button listeners
    @objc func btnSaveClick() {
        plan?.planElements = contentLayout?.planElementTableView.dataList
        
        if let name = CreatePlanViewController.staticName {
            plan?.name = name
            CreatePlanViewController.staticName = nil
        }
        
        if let notes = CreatePlanViewController.staticNotes {
            plan?.notes = notes
            CreatePlanViewController.staticNotes = nil
        }
        
        if isEdit {
            finishEditPlanDetailsVc(viewController: self, plan: plan!)
        } else {
            startPlanDetailsViewController(viewController: self, plan: plan!, isEdit: true)
        }
    }
    
    @objc func clickPlay() {
        plan?.planElements = contentLayout?.planElementTableView.dataList
        startTrainingEnvTypeVc(navigationViewController: self.navigationController!, plan: plan, event: nil)
    }
    
    func onClicked(value: Int) {
        if value == KeyboardNumView.valueNext {
            let intensity = Int(contentLayout!.etIntensity.text) ?? 0
            let value = createValue()
            let planElement = PlanElement(planId: plan!.planId, intensity: intensity, type: plan!.type, value: value)
            
            contentLayout?.planElementTableView.addPlanElement(planElement: planElement)
            
            tableViewScrollToBottom(animated: true)
        }
    }
    
    private func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.contentLayout?.planElementTableView.numberOfSections
            let numberOfRows = self.contentLayout!.planElementTableView.numberOfRows(inSection: numberOfSections!-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections!-1))
                self.contentLayout?.planElementTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    //MARK: delegate
    func hasFocus(planEditText: PlanEditText) {
        activeTextView = planEditText
    }
    
    func onTextChanged(etType: PlanTextType, hasText: Bool) {
        checkEnterEnable()
    }
    
    //MARK: functions
    private func createValue() -> Double {
        switch plan!.type {
        case PlanType.distance:
            return UnitHelper.getMetricDistanceValue(value: Double(contentLayout!.etDistance.text) ?? 0)
        case PlanType.time:
            let minutes = Int(contentLayout!.etMinute.text) ?? 0
            let sec = Int(contentLayout!.etSec.text) ?? 0
            
            let value = (minutes * 60 + sec) * 1000
            return Double(value)
        default:
            fatalError("no other types")
        }
    }
    
    private func checkEnterEnable() {
        var enable = contentLayout!.planElementTableView.positionToAdd >= 0
        
        if PlanType.distance == plan?.type {
            enable = enable && contentLayout!.etDistance.hasText && contentLayout!.etIntensity.hasText
        } else {
            enable = enable && contentLayout!.etMinute.isHasText && contentLayout!.etSec.isHasText && contentLayout!.etIntensity.isHasText
        }
        
        contentLayout?.keyboardView.enableEnter(isEnable: enable)
    }
    
}
