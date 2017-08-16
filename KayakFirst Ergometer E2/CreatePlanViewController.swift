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
    
    //MARK: constants
    private let btnDeleteRadius: CGFloat = 400
    private let fontSize: CGFloat = 30
    private let fontSizeEdit: CGFloat = 28
    
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
        contentView.addSubview(planElementTableView)
        planElementTableView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(margin05)
            make.top.equalTo(contentView).offset(margin05)
            make.bottom.equalTo(contentView)
            make.width.equalTo(95)
        }
        
        contentView.addSubview(intensityView)
        intensityView.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.right.equalTo(contentView).offset(-margin05)
            make.top.equalTo(planElementTableView)
            make.height.equalTo(55)
        }
        
        contentView.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { (make) in
            make.top.equalTo(intensityView.snp.bottom).offset(margin2)
            make.right.equalTo(intensityView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-128)
            make.left.equalTo(planElementTableView.snp.right).offset(margin05)
        }
        
        setUIForType()
        
        contentView.addSubview(viewDelete)
        viewDelete.snp.makeConstraints { (make) in
            let offset = (btnDeleteRadius / 2)
            make.right.equalTo(contentView).offset(offset)
            make.top.equalTo(contentView).offset(-offset)
            make.height.equalTo(self.btnDeleteRadius)
            make.width.equalTo(self.btnDeleteRadius)
        }
    }
    
    override func initTabBarItems() {
        showCloseButton()
        showLogoCenter(viewController: self)
        self.navigationItem.setRightBarButtonItems([btnSave, btnPlay], animated: true)
    }
    
    private func setUIForType() {
        if planType == nil {
            planType = plan!.type
        }
        
        var viewToAdd: UIView? = nil
        switch planType! {
        case PlanType.distance:
            viewToAdd = distanceView
            break
        case PlanType.time:
            viewToAdd = timeView
            break
        default:
            break
        }
        
        if plan == nil {
            plan = Plan(type: planType!)
        } else {
            isEdit = true
        }
        
        planElementTableView.type = plan?.type
        planElementTableView.addPlanElementsAll(planElements: plan?.planElements)
        
        contentView.addSubview(viewToAdd!)
        viewToAdd!.snp.makeConstraints({ (make) in
            make.left.equalTo(keyboardView)
            make.top.equalTo(intensityView)
            make.bottom.equalTo(intensityView)
            make.right.equalTo(intensityView.snp.left).offset(-margin05)
        })
    }
    
    //MARK: views
    private lazy var keyboardView: KeyboardNumView! = {
        let keyboardView = KeyboardNumView()
        
        keyboardView.createPlanViewController = self
        keyboardView.keyboardClickListener = self
        
        return keyboardView
    }()
    
    private lazy var distanceView: UIView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(self.etDistance)
        
        let labelUnit = BebasUILabel()
        labelUnit.text = UnitHelper.getDistanceUnit()
        labelUnit.font = labelUnit.font.withSize(self.fontSize)
        labelUnit.textAlignment = .center
        labelUnit.snp.makeConstraints({ (make) in
            make.width.equalTo(self.fontSize)
        })
        
        stackView.addArrangedSubview(labelUnit)
        
        return stackView
    }()
    
    private lazy var timeView: UIView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        stackView.addArrangedSubview(self.etMinute)
        
        let label = UILabel()
        label.text = ":"
        label.textAlignment = .center
        label.font = label.font.withSize(self.fontSize)
        
        stackView.addArrangedSubview(label)
        
        stackView.addArrangedSubview(self.etSec)
        
        self.etMinute.snp.makeConstraints({ (make) in
            make.width.equalTo(self.etSec)
        })
        
        return stackView
    }()
    
    private lazy var intensityView: UIView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(self.etIntensity)
        
        self.etIntensity.snp.makeConstraints({ (make) in
            make.width.equalTo(self.fontSizeEdit)
        })
        
        let labelPercent = BebasUILabel()
        labelPercent.text = "%"
        labelPercent.textAlignment = .center
        labelPercent.font = labelPercent.font.withSize(20)
        
        labelPercent.snp.makeConstraints({ (make) in
            make.width.equalTo(self.fontSize / 2)
        })
        
        stackView.addArrangedSubview(labelPercent)

        return stackView
    }()
    
    private lazy var etMinute: PlanEtMinute! = {
        let et = PlanEtMinute()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.hint = getString("plan_hint_minute")
        
        et.onFocusedListener = self
        et.onTextChangedListener = self
        
        return et
    }()
    
    private lazy var etSec: PlanEtSec! = {
        let et = PlanEtSec()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.hint = getString("plan_hint_sec")
        
        et.onFocusedListener = self
        et.onTextChangedListener = self
        
        return et
    }()
    
    private lazy var etIntensity: PlanEtIntensity! = {
        let et = PlanEtIntensity()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.hint = getString("plan_hint_percent")
        
        et.onFocusedListener = self
        et.onTextChangedListener = self
        
        return et
    }()
    
    private lazy var etDistance: PlanEtDistance! = {
        let et = PlanEtDistance()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.hint = UnitHelper.getDistanceUnit()
        
        et.onFocusedListener = self
        et.onTextChangedListener = self
        
        return et
    }()
    
    private lazy var planElementTableView: PlanElementTableView! = {
        let view = PlanElementTableView(view: self.contentView)
        
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPress)))
        
        return view
    }()
    
    private lazy var viewDelete: UIView! = {
        let view = UIView()
        
        view.addSubview(self.backgroundDelete)
        self.backgroundDelete.snp.makeConstraints({ (make) in
            make.center.equalTo(view)
        })
        view.addSubview(self.imgDelete)
        self.imgDelete.snp.makeConstraints({ (make) in
            make.center.equalTo(view).inset(UIEdgeInsetsMake(40, -40, 0, 0))
        })
        
        view.isHidden = true
        
        return view
    }()
    
    private lazy var imgDelete: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "trashDropShadow")
        
        return imageView
    }()
    
    private lazy var backgroundDelete: RoundButton! = {
        let button = RoundButton(radius: self.btnDeleteRadius, image: UIImage(named: ""), color: Colors.colorTransparent)
        button.applyGradient(withColours: [Colors.colorDeleteEnd, Colors.colorDeleteStart], gradientOrientation: GradientOrientation.topRightBottomLeft)
        
        return button
    }()
    
    //MARK: tabbarItems
    private lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "save")
        button.target = self
        button.action = #selector(btnSaveClick)
        
        return button
    }()
    
    private lazy var btnPlay: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "playSmall")
        button.target = self
        button.action = #selector(clickPlay)
        
        return button
    }()
    
    //MARK: button listeners
    @objc func btnSaveClick() {
        plan?.planElements = planElementTableView.dataList
        
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
        plan?.planElements = planElementTableView.dataList
        startMainVc(navigationViewController: self.navigationController!, plan: plan, event: nil)
    }
    
    func onClicked(value: Int) {
        if value == KeyboardNumView.valueNext {
            let intensity = Int(etIntensity.text) ?? 0
            let value = createValue()
            let planElement = PlanElement(planId: plan!.planId, intensity: intensity, type: plan!.type, value: value)
            
            planElementTableView.addPlanElement(planElement: planElement)
            
            tableViewScrollToBottom(animated: true)
        }
    }
    
    private func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.planElementTableView.numberOfSections
            let numberOfRows = self.planElementTableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.planElementTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
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
            return UnitHelper.getMetricDistanceValue(value: Double(etDistance.text) ?? 0)
        case PlanType.time:
            let minutes = Int(etMinute.text) ?? 0
            let sec = Int(etSec.text) ?? 0
            
            let value = (minutes * 60 + sec) * 1000
            return Double(value)
        default:
            fatalError("no other types")
        }
    }
    
    private func checkEnterEnable() {
        var enable = planElementTableView.positionToAdd >= 0
        
        if PlanType.distance == plan?.type {
            enable = enable && etDistance.hasText && etIntensity.hasText
        } else {
            enable = enable && etMinute.isHasText && etSec.isHasText && etIntensity.isHasText
        }
        
        keyboardView.enableEnter(isEnable: enable)
    }
    
    //MARK: drag drop
    @objc private func onLongPress(gestureRecognizer: UIGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: contentView)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            
            let tableLocation = gestureRecognizer.location(in: planElementTableView)
            indexPath = planElementTableView.indexPathForRow(at: tableLocation)
            draggedView = planElementTableView.cellForRow(at: indexPath!) as! UITableViewCell
            
            if draggedView is PECellNormal {
                if isDragEnded {
                    if self.snapShot == nil {
                        
                        self.snapShot?.layer.cornerRadius = draggedView?.layer.cornerRadius ?? 0
                        
                        viewDelete.isHidden = false
                        
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
                
                shouldDelete = viewDelete.isDragDropEnter(superView: contentView, gestureRecognizer: gestureRecognizer)
            }
        default:
            if shouldDelete {
                resetDrag()
                planElementTableView.deletePlanElement(position: (indexPath?.row)!)
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
        self.viewDelete.isHidden = true
    }
    
}