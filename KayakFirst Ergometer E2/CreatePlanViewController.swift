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
    createPlanVc.plan = Plan(type: planType)
    
    navigationVc.pushViewController(createPlanVc, animated: false)
    viewController.present(navigationVc, animated: true, completion: nil)
}

class CreatePlanViewController: BaseVC, UITextViewDelegate, OnKeyboardClickedListener {
    
    //MARK: constants
    private let btnDeleteRadius: CGFloat = 400
    private let fontSize: CGFloat = 28
    private let fontSizeEdit: CGFloat = 32
    
    //MARK: properties
    var plan: Plan?
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
            make.left.equalTo(contentView).offset(margin05)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.width.equalTo(100)
        }
        
        contentView.addSubview(intensityView)
        intensityView.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.right.equalTo(contentView).offset(-margin05)
            make.top.equalTo(contentView).offset(margin05)
            make.height.equalTo(70)
        }
        
        contentView.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { (make) in
            make.top.equalTo(intensityView.snp.bottom).offset(margin)
            make.right.equalTo(intensityView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-128)
            make.left.equalTo(planElementTableView.snp.right).offset(margin)
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
        planElementTableView.type = plan?.type
        planElementTableView.planId = plan?.planId
        
        var viewToAdd: UIView? = nil
        
        switch plan!.type {
        case PlanType.distance:
            viewToAdd = distanceView
            break
        case PlanType.time:
            viewToAdd = timeView
            break
        default:
            fatalError("no other type")
        }
        
        contentView.addSubview(viewToAdd!)
        viewToAdd!.snp.makeConstraints({ (make) in
            make.left.equalTo(keyboardView)
            make.top.equalTo(intensityView)
            make.bottom.equalTo(intensityView)
            make.right.equalTo(intensityView.snp.left).offset(-margin)
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
        labelUnit.text = getString("unit_distance")
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
        labelPercent.font = labelPercent.font.withSize(self.fontSize)
        
        labelPercent.snp.makeConstraints({ (make) in
            make.width.equalTo(self.fontSize)
        })
        
        stackView.addArrangedSubview(labelPercent)

        return stackView
    }()
    
    private lazy var etMinute: NoImeEditText! = {
        let et = NoImeEditText()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.delegate = self
        
        return et
    }()
    
    private lazy var etSec: NoImeEditText! = {
        let et = NoImeEditText()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.delegate = self
        
        return et
    }()
    
    private lazy var etIntensity: NoImeEditText! = {
        let et = NoImeEditText()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.delegate = self
        
        return et
    }()
    
    private lazy var etDistance: NoImeEditText! = {
        let et = NoImeEditText()
        et.font = et.font?.withSize(self.fontSizeEdit)
        
        et.delegate = self
        
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
        button.applyGradient(withColours: [Colors.colorDeleteStart, Colors.colorDeleteEnd], gradientOrientation: GradientOrientation.topRightBottomLeft)
        //button.backgroundColor = Colors.colorDeleteStart
        
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
        startPlanDetailsViewController(viewController: self, plan: plan!, isEdit: true)
        //TODO
        //self.dismiss(animated: false, completion: nil)
    }
    
    @objc func clickPlay() {
        plan?.planElements = planElementTableView.dataList
        startTrainingViewController(viewController: self, plan: plan!)
    }
    
    //MARK: delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func onClicked(value: Int) {
        if value == KeyboardNumView.valueNext {
            let intensity = Int(etIntensity.text) ?? 0
            let value = createValue()
            let planElement = PlanElement(planId: plan!.planId, intensity: intensity, type: plan!.type, value: value)
            
            planElementTableView.addPlanElement(planElement: planElement)
        }
    }
    
    //MARK: functions
    private func createValue() -> Int64 {
        switch plan!.type {
        case PlanType.distance:
            return Int64(etDistance.text) ?? 0
        case PlanType.time:
            let minutes = Int(etMinute.text) ?? 0
            let sec = Int(etSec.text) ?? 0
            
            let value = (minutes * 60 + sec) * 1000
            return Int64(value)
        default:
            fatalError("no other types")
        }
    }
    
    //MARK: drag drop
    //MARK: listeners
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
                        viewDelete.isHidden = false
                        
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
            }
        case UIGestureRecognizerState.changed:
            if let dragView = self.snapShot {
                dragView.center = locationInView
                
                shouldDelete = viewDelete.isDragDropEnter(superView: contentView, gestureRecognizer: gestureRecognizer)
            }
        default:
            self.snapShot?.removeFromSuperview()
            self.draggedView?.isHidden = false
            self.snapShot = nil
            self.draggedView = nil
            isDragEnded = true
            viewDelete.isHidden = true
            
            if shouldDelete {
                planElementTableView.deletePlanElement(position: (indexPath?.row)!)
            }
            shouldDelete = false
        }
    }
    
}
