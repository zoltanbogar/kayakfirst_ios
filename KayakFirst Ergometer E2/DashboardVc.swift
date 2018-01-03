//
//  DashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashboardVc: BaseVC<VcDashobardLayout>, CycleStateChangeListener {
    
    //MARK: constants
    private let btnPlayState = 0
    private let btnRestartState = 1
    
    //MARK: properties
    private let telemetry = Telemetry.sharedInstance
    
    private var btnPauseOriginalX: CGFloat = 0
    private var btnPauseOriginalY: CGFloat = 0
    
    private let batterySaveHelper = BatterySaveHelper()
    private var isBatterySaveShouldActive = false
    
    var plan: Plan?
    private let planManager = PlanManager.sharedInstance
    private var planTraining: PlanTraining?
    
    var event: Event?
    
    private var sessionId: Double = 0
    
    private var shouldCloseParents = false
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        telemetry.dashboardCycleStateChangeListener = self
        
        onCycleStateChanged(newCycleState: telemetry.cycleState!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        batterySaveHelper.activate(isActivate: isBatterySaveShouldActive)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        batterySaveHelper.activate(isActivate: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentLayout!.viewDashboardPlan.viewDidLayoutSubViews()
    }
    
    //MARK: button listeners
    @objc private func btnPlayPauseClick() {
        if let parent = self.parent as? TrainingViewControllerOld {
            if telemetry.cycleState == CycleState.resumed {
                parent.onPauseClicked()
            } else if telemetry.cycleState != CycleState.paused {
                switch parent.trainingEnvType! {
                case TrainingEnvironmentType.outdoor:
                    parent.outdoorService.startLocationMonitoring()
                    parent.calibrationView?.showView()
                case TrainingEnvironmentType.ergometer:
                    parent.onCalibrationEnd()
                default:
                    break
                }
            }
        }
    }
    
    @objc private func btnPlayClick() {
        if let parent = self.parent as? TrainingViewControllerOld {
            if telemetry.cycleState == CycleState.paused {
                parent.onCounterEnd()
            }
        }
    }
    
    @objc private func btnStopClick() {
        if let parent = self.parent as? TrainingViewControllerOld {
            parent.onStopClicked()
        }
    }
    
    @objc internal override func btnCloseClick() {
        if let parent = self.parent as? TrainingViewControllerOld {
            parent.closeViewController(shoudlCloseParents: shouldCloseParents)
        }
    }
    
    @objc internal func clickPowerSaveOn() {
        isBatterySaveShouldActive = true
        showPowerSaveOn(isShow: true)
        batterySaveHelper.activate(isActivate: true)
    }
    
    @objc internal func clickPowerSaveOff() {
        isBatterySaveShouldActive = false
        showPowerSaveOn(isShow: false)
        batterySaveHelper.activate(isActivate: false)
    }
    
    //MARK: cycle state
    func onCycleStateChanged(newCycleState: CycleState) {
        DispatchQueue.main.async {
            self.shouldCloseParents = false
            self.showViewSwipePause(false)
            self.showPauseView(false)
            switch newCycleState {
            case CycleState.idle:
                self.initBtnPlaySmall(btnPlayPauseIcon: self.btnPlayState, isShow: true)
                self.refreshDashboardElements(false)
            case CycleState.stopped:
                self.shouldCloseParents = true
                self.initBtnPlaySmall(btnPlayPauseIcon: self.btnRestartState, isShow: true)
                self.refreshDashboardElements(false)
                self.batterySaveHelper.activate(isActivate: false)
                self.savePlan()
            case CycleState.paused:
                self.showPauseView(true)
                self.initBtnPlaySmall(btnPlayPauseIcon: self.btnRestartState, isShow: false)
                self.batterySaveHelper.activate(isActivate: false)
            case CycleState.resumed:
                self.showViewSwipePause(true)
                self.initBtnPlaySmall(btnPlayPauseIcon: self.btnPlayState, isShow: false)
                self.refreshDashboardElements(true)
                self.batterySaveHelper.activate(isActivate: self.isBatterySaveShouldActive)
                
                self.sessionId = self.telemetry.sessionId
            default: break
            }
            self.showBackButton()
        }
    }
    
    func setPlanToPlanView() {
        if plan != nil {
            planTraining = PlanTraining.createPlanTraining(plan: plan!)
        }
        
        contentLayout!.setPlantoPlanView()
    }
    
    private func showPauseView(_ isShow: Bool) {
        contentLayout!.pauseView.isHidden = !isShow
    }
    
    private func showViewSwipePause(_ isShow: Bool) {
        contentLayout!.viewSwipePause.isHidden = !isShow
    }
    
    private func initBtnPlaySmall(btnPlayPauseIcon: Int, isShow: Bool) {
        contentLayout!.btnPlaySmall.isHidden = true
        
        var image: UIImage = UIImage(named: "ic_play_48dp")!
        switch btnPlayPauseIcon {
        case btnRestartState:
            image = UIImage(named: "ic_refresh_white_48pt")!
        default:
            break
        }
        
        contentLayout!.btnPlaySmall.image = image
        contentLayout!.btnPlaySmall.isHidden = !isShow
    }
    
    private func showBackButton() {
        if telemetry.cycleState != nil {
            switch telemetry.cycleState! {
            case CycleState.idle:
                self.navigationItem.setHidesBackButton(false, animated: true)
                if plan == nil {
                    removeCloseButton()
                }
            case CycleState.stopped:
                self.navigationItem.setHidesBackButton(true, animated: true)
                showCloseButton()
            case CycleState.paused:
                self.navigationItem.setHidesBackButton(true, animated: true)
                removeCloseButton()
            case CycleState.resumed:
                self.navigationItem.setHidesBackButton(true, animated: true)
                removeCloseButton()
            default: break
            }
        }
    }
    
    private func refreshDashboardElements(_ isRefresh: Bool) {
        contentLayout!.dashboardElement0?.startRefresh(isRefresh)
        contentLayout!.dashboardElement1?.startRefresh(isRefresh)
        contentLayout!.dashboardElement2?.startRefresh(isRefresh)
        contentLayout!.dashboardElement3?.startRefresh(isRefresh)
        contentLayout!.dashboardElement4?.startRefresh(isRefresh)
        
        if plan != nil {
            if isRefresh {
                contentLayout!.viewDashboardPlan.startRefresh(true)
            } else {
                contentLayout!.viewDashboardPlan.stopRefresh()
            }
        } else {
            contentLayout!.viewDashboardPlan.stopRefresh()
        }
    }
    
    //MARK: views
    override func initView() {
        super.initView()
        
        contentLayout!.btnPlaySmall.addTarget(self, action: #selector(btnPlayPauseClick), for: .touchUpInside)
        contentLayout!.btnPause.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(animateBtnPause(pan:))))
        contentLayout!.btnPlay.addTarget(self, action: #selector(btnPlayClick), for: .touchUpInside)
        contentLayout!.btnStop.addTarget(self, action: #selector(btnStopClick), for: .touchUpInside)
        
        contentLayout!.btnPowerSaveOn.target = self
        contentLayout!.btnPowerSaveOn.action = #selector(clickPowerSaveOff)
        contentLayout!.btnPowerSaveOff.target = self
        contentLayout!.btnPowerSaveOff.action = #selector(clickPowerSaveOn)
    }
    
    override func getContentLayout(contentView: UIView) -> VcDashobardLayout {
        return VcDashobardLayout(contentView: contentView, dashboardLayoutDict: (parent as! TrainingViewControllerOld).dashboardLayoutDict, plan: plan)
    }
    
    private func savePlan() {
        if plan != nil && planTraining != nil {
            if planTraining?.sessionId == 0 {
                planTraining?.sessionId = sessionId
            }
            
            planManager.savePlanTraining(planTraining: planTraining!)
        }
        
        if event != nil && contentLayout!.viewDashboardPlan.isDone {
            event?.sessionId = sessionId
            
            EventManager.sharedInstance.saveEvent(event: event!, managerCallBack: nil)
        }
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
        if plan != nil {
            showCloseButton()
        }
        showPowerSaveOn(isShow: false)
    }
    
    private func showPowerSaveOn(isShow: Bool) {
        var menuItem: [UIBarButtonItem] = [contentLayout!.btnPowerSaveOff]
        if isShow {
            menuItem = [contentLayout!.btnPowerSaveOn]
        }
        
        if let parent = self.parent as? TrainingViewControllerOld {
            if parent.trainingEnvType == TrainingEnvironmentType.ergometer {
                menuItem.append(parent.bluetoothTabBarItem)
            }
        }
        self.navigationItem.setRightBarButtonItems(menuItem, animated: true)
    }
    
    //MARK: animation
    @objc private func animateBtnPause(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: self.view)
        
        switch pan.state {
        case .began:
            btnPauseOriginalX = pan.view!.center.x
            btnPauseOriginalY = pan.view!.center.y
        case .changed:
            var diffX = btnPauseOriginalX
            var diffY = btnPauseOriginalY
            
            var swipe: CGFloat = 0
            
            if contentLayout!.isLandscape {
                let diffYGlobal = pan.view!.center.y + translation.y
                diffY = diffYGlobal < btnPauseOriginalY ? diffYGlobal : btnPauseOriginalY
                swipe = btnPauseOriginalY - diffY
            } else {
                let diffXGlobal = pan.view!.center.x + translation.x
                diffX = diffXGlobal > btnPauseOriginalX ? diffXGlobal : btnPauseOriginalX
                swipe = abs(btnPauseOriginalX - diffX)
            }
            
            if swipe > (dashboardPauseSwipeArea - 75) {
                animateBtnPlayPauseToOriginal()
                btnPlayPauseClick()
            } else {
                pan.view!.center = CGPoint(x: diffX, y: diffY)
                pan.setTranslation(CGPoint.zero, in: self.view)
            }
        case .ended:
            animateBtnPlayPauseToOriginal()
        default:
            break
        }
    }
    
    private func animateBtnPlayPauseToOriginal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentLayout!.btnPause.center = CGPoint(x: self.btnPauseOriginalX, y: self.btnPauseOriginalY)
        })
    }
}
