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

class CreatePlanViewController: BaseVC, OnFocusedListener, OnKeyboardClickedListener, OnTextChangedListener {
    
    //MARK: properties
    var plan: Plan?
    var planType: PlanType?
    
    private var isEdit = false
    
    static var staticName: String?
    static var staticNotes: String?
    
    private var snapShot: UIView?
    private var draggedView: UIView?
    private var indexPath: IndexPath?
    private var isDragEnded = true
    private var shouldDelete = false
    private var draggedViewOriginalX: CGFloat = 0
    private var draggedViewOriginalY: CGFloat = 0
    
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
        
        //TODO: move this to BaseVc
        self.contentLayout = getContentLayout(contentView: contentView)
        self.contentLayout?.setView()
        ///////////////////////////
        
        setUiForType()
        
        (contentLayout as! VcCreatePlanLayout).keyboardView.createPlanViewController = self
        (contentLayout as! VcCreatePlanLayout).keyboardView.keyboardClickListener = self
        
        (contentLayout as! VcCreatePlanLayout).etMinute.onFocusedListener = self
        (contentLayout as! VcCreatePlanLayout).etMinute.onTextChangedListener = self
        (contentLayout as! VcCreatePlanLayout).etSec.onFocusedListener = self
        (contentLayout as! VcCreatePlanLayout).etSec.onTextChangedListener = self
        (contentLayout as! VcCreatePlanLayout).etIntensity.onFocusedListener = self
        (contentLayout as! VcCreatePlanLayout).etIntensity.onTextChangedListener = self
        (contentLayout as! VcCreatePlanLayout).etDistance.onFocusedListener = self
        (contentLayout as! VcCreatePlanLayout).etDistance.onTextChangedListener = self
        
        (contentLayout as! VcCreatePlanLayout).planElementTableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPress)))
        
        (contentLayout as! VcCreatePlanLayout).btnSave.target = self
        (contentLayout as! VcCreatePlanLayout).btnSave.action = #selector(btnSaveClick)
        (contentLayout as! VcCreatePlanLayout).btnPlay.target = self
        (contentLayout as! VcCreatePlanLayout).btnPlay.action = #selector(clickPlay)
    }
    
    override func getContentLayout(contentView: UIView) -> VcCreatePlanLayout {
        return VcCreatePlanLayout(contentView: contentView)
    }
    
    private func setUiForType() {
        if planType == nil {
            planType = plan!.type
        }
        
        (contentLayout as! VcCreatePlanLayout).setUIForType(planType: planType!)
        
        if plan == nil {
            plan = Plan(type: planType!)
        } else {
            isEdit = true
        }
        
        (contentLayout as! VcCreatePlanLayout).planElementTableView.type = plan?.type
        (contentLayout as! VcCreatePlanLayout).planElementTableView.addPlanElementsAll(planElements: plan?.planElements)
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
        self.navigationItem.setRightBarButtonItems([(contentLayout as! VcCreatePlanLayout).btnSave, (contentLayout as! VcCreatePlanLayout).btnPlay], animated: true)
    }
    
    //MARK: button listeners
    @objc func btnSaveClick() {
        plan?.planElements = (contentLayout as! VcCreatePlanLayout).planElementTableView.dataList
        
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
        plan?.planElements = (contentLayout as! VcCreatePlanLayout).planElementTableView.dataList
        startMainVc(navigationViewController: self.navigationController!, plan: plan, event: nil)
    }
    
    func onClicked(value: Int) {
        if value == KeyboardNumView.valueNext {
            let intensity = Int((contentLayout as! VcCreatePlanLayout).etIntensity.text) ?? 0
            let value = createValue()
            let planElement = PlanElement(planId: plan!.planId, intensity: intensity, type: plan!.type, value: value)
            
            (contentLayout as! VcCreatePlanLayout).planElementTableView.addPlanElement(planElement: planElement)
            
            tableViewScrollToBottom(animated: true)
        }
    }
    
    private func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = (self.contentLayout as! VcCreatePlanLayout).planElementTableView.numberOfSections
            let numberOfRows = (self.contentLayout as! VcCreatePlanLayout).planElementTableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                (self.contentLayout as! VcCreatePlanLayout).planElementTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
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
            return UnitHelper.getMetricDistanceValue(value: Double((contentLayout as! VcCreatePlanLayout).etDistance.text) ?? 0)
        case PlanType.time:
            let minutes = Int((contentLayout as! VcCreatePlanLayout).etMinute.text) ?? 0
            let sec = Int((contentLayout as! VcCreatePlanLayout).etSec.text) ?? 0
            
            let value = (minutes * 60 + sec) * 1000
            return Double(value)
        default:
            fatalError("no other types")
        }
    }
    
    private func checkEnterEnable() {
        var enable = (contentLayout as! VcCreatePlanLayout).planElementTableView.positionToAdd >= 0
        
        if PlanType.distance == plan?.type {
            enable = enable && (contentLayout as! VcCreatePlanLayout).etDistance.hasText && (contentLayout as! VcCreatePlanLayout).etIntensity.hasText
        } else {
            enable = enable && (contentLayout as! VcCreatePlanLayout).etMinute.isHasText && (contentLayout as! VcCreatePlanLayout).etSec.isHasText && (contentLayout as! VcCreatePlanLayout).etIntensity.isHasText
        }
        
        (contentLayout as! VcCreatePlanLayout).keyboardView.enableEnter(isEnable: enable)
    }
    
    //MARK: drag drop
    @objc private func onLongPress(gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: contentView)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            
            let tableLocation = gestureRecognizer.location(in: (contentLayout as! VcCreatePlanLayout).planElementTableView)
            indexPath = (contentLayout as! VcCreatePlanLayout).planElementTableView.indexPathForRow(at: tableLocation)
            draggedView = (contentLayout as! VcCreatePlanLayout).planElementTableView.cellForRow(at: indexPath!) as! UITableViewCell
            
            if draggedView is PECellNormal {
                if isDragEnded {
                    if self.snapShot == nil {
                        
                        self.snapShot?.layer.cornerRadius = draggedView?.layer.cornerRadius ?? 0
                        
                        (contentLayout as! VcCreatePlanLayout).viewDelete.isHidden = false
                        
                        self.draggedViewOriginalX = locationInView.x
                        self.draggedViewOriginalY = locationInView.y
                        
                        self.snapShot = draggedView!.getSnapshotView()
                        self.contentView.addSubview(self.snapShot!)
                        self.snapShot!.snp.makeConstraints { make in
                            make.center.equalTo(locationInView)
                        }
                        draggedView?.isHidden = true
                    }
                    isDragEnded = false
                }
            }
        case UIGestureRecognizerState.changed:
            if let dragView = self.snapShot {
                dragView.center = locationInView
                
                shouldDelete = (contentLayout as! VcCreatePlanLayout).viewDelete.isDragDropEnter(superView: contentView, gestureRecognizer: gestureRecognizer)
            }
        default:
            if shouldDelete {
                resetDrag()
                (contentLayout as! VcCreatePlanLayout).planElementTableView.deletePlanElement(position: (indexPath?.row)!)
            } else {
                animateDraggedViewToOriginal()
            }
            shouldDelete = false
        }
    }
    
    private func animateDraggedViewToOriginal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.snapShot?.center = CGPoint(x: self.draggedViewOriginalX, y: self.draggedViewOriginalY)
        }, completion: { ended in
            self.resetDrag()
        })
    }
    
    private func resetDrag() {
        self.snapShot?.removeFromSuperview()
        self.draggedView?.isHidden = false
        self.snapShot = nil
        self.draggedView = nil
        self.isDragEnded = true
        (contentLayout as! VcCreatePlanLayout).viewDelete.isHidden = true
    }
    
}
