//
//  DashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashboardVc: BaseVC, CycleStateChangeListener {
    
    //MARK: constants
    private let btnPlayState = 0
    private let btnRestartState = 1
    private let swipeArea: CGFloat = 180
    
    //MARK: properties
    private let telemetry = Telemetry.sharedInstance
    private var dashboardElement0: DashBoardElement?
    private var dashboardElement1: DashBoardElement?
    private var dashboardElement2: DashBoardElement?
    private var dashboardElement3: DashBoardElement?
    private var dashboardElement4: DashBoardElement?
    
    private var btnPauseOriginalX: CGFloat = 0
    private var btnPauseOriginalY: CGFloat = 0
    private var isLandscape = false
    
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
        
        viewDashboardPlan.viewDidLayoutSubViews()
    }
    
    //MARK: button listeners
    @objc private func btnPlayPauseClick() {
        if let parent = self.parent as? TrainingViewController {
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
        if let parent = self.parent as? TrainingViewController {
            if telemetry.cycleState == CycleState.paused {
                parent.onCounterEnd()
            }
        }
    }
    
    @objc private func btnStopClick() {
        if let parent = self.parent as? TrainingViewController {
            parent.onStopClicked()
        }
    }
    
    @objc internal override func btnCloseClick() {
        if let parent = self.parent as? TrainingViewController {
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
                self.refreshDashboardElements(false)
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
    
    private func showPauseView(_ isShow: Bool) {
        pauseView.isHidden = !isShow
    }
    
    private func showViewSwipePause(_ isShow: Bool) {
        viewSwipePause.isHidden = !isShow
    }
    
    private func initBtnPlaySmall(btnPlayPauseIcon: Int, isShow: Bool) {
        btnPlaySmall.isHidden = true
        
        var image: UIImage = UIImage(named: "ic_play_48dp")!
        switch btnPlayPauseIcon {
        case btnRestartState:
            image = UIImage(named: "ic_refresh_white_48pt")!
        default:
            break
        }
        
        btnPlaySmall.image = image
        btnPlaySmall.isHidden = !isShow
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
        dashboardElement0?.startRefresh(isRefresh)
        dashboardElement1?.startRefresh(isRefresh)
        dashboardElement2?.startRefresh(isRefresh)
        dashboardElement3?.startRefresh(isRefresh)
        dashboardElement4?.startRefresh(isRefresh)
        
        if plan != nil {
            if isRefresh {
                viewDashboardPlan.startRefresh(true)
            } else {
                viewDashboardPlan.stopRefresh()
            }
        } else {
            viewDashboardPlan.stopRefresh()
        }
    }
    
    //MARK: views
    override func initView() {
        buttonView.addSubview(viewSwipePause)
        
        buttonView.addSubview(btnPlaySmall)
        btnPlaySmall.snp.makeConstraints { make in
            make.center.equalTo(buttonView)
        }
        
        mainStackView.removeAllSubviews()
        
        initDashboardViews()
        
        mainStackView.addArrangedSubview(buttonView)
        
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        contentView.backgroundColor = Colors.colorDashBoardDivider
    }
    
    private func initDashboardViews() {
        var viewToShow: UIView = viewDashboard
        
        if let parent = self.navigationController as? TrainingViewController {
            for (position, tag) in parent.dashboardLayoutDict {
                let dashboardElement = DashBoardElement.getDashBoardElementByTag(tag: tag, isValueVisible: true)
                var view: UIView?
                switch position {
                case 0:
                    view = viewDashboard.view0
                    dashboardElement0 = dashboardElement
                case 1:
                    view = viewDashboard.view1
                    dashboardElement1 = dashboardElement
                case 2:
                    view = viewDashboard.view2
                    dashboardElement2 = dashboardElement
                case 3:
                    view = viewDashboard.view3
                    dashboardElement3 = dashboardElement
                case 4:
                    view = viewDashboard.view4
                    dashboardElement4 = dashboardElement
                default:
                    fatalError()
                }
                
                if let newView = view {
                    newView.removeAllSubviews()
                    newView.addSubview(dashboardElement)
                    dashboardElement.snp.makeConstraints { make in
                        make.edges.equalTo(newView)
                    }
                }
            }
        }
        if plan != nil {
            viewToShow = viewDashboardPlan
            setPlantoPlanView()
        }
        
        mainStackView.addArrangedSubview(viewToShow)
    }
    
    func setPlantoPlanView() {
        if plan != nil {
            planTraining = PlanTraining.createPlanTraining(plan: plan!)
        }
        
        viewDashboardPlan.plan = plan
    }
    
    private func savePlan() {
        if plan != nil && planTraining != nil {
            if planTraining?.sessionId == 0 {
                planTraining?.sessionId = sessionId
            }
            
            planManager.savePlanTraining(planTraining: planTraining!)
        }
        
        if event != nil && viewDashboardPlan.isDone {
            event?.sessionId = sessionId
            
            EventManager.sharedInstance.saveEvent(event: event!, managerCallBack: nil)
        }
    }

    //MARK: screen orieantation
    override func handlePortraitLayout(size: CGSize) {
        mainStackView.axis = .vertical
        pauseStackView.axis = .vertical
        
        buttonView.snp.removeConstraints()
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(mainStackView)
        }
        
        viewSwipePause.snp.removeConstraints()
        viewSwipePause.snp.makeConstraints { (make) in
            make.center.equalTo(buttonView)
            make.width.equalTo(swipeArea)
            make.height.equalTo(75)
        }
        btnPause.snp.removeConstraints()
        btnPause.snp.makeConstraints { (make) in
            make.left.equalTo(viewSwipePause)
            make.centerY.equalTo(viewSwipePause)
        }
        
        isLandscape = false
        
        setDashboardElementsOrientation()
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        mainStackView.axis = .horizontal
        pauseStackView.axis = .horizontal
        
        buttonView.snp.removeConstraints()
        buttonView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(mainStackView)
        }
        
        viewSwipePause.snp.removeConstraints()
        viewSwipePause.snp.makeConstraints { (make) in
            make.center.equalTo(buttonView)
            make.width.equalTo(75)
            make.height.equalTo(swipeArea)
        }
        btnPause.snp.removeConstraints()
        btnPause.snp.makeConstraints { (make) in
            make.bottom.equalTo(viewSwipePause)
            make.centerX.equalTo(viewSwipePause)
        }
        
        isLandscape = true
        
        setDashboardElementsOrientation()
    }
    
    private func setDashboardElementsOrientation() {
        (viewDashboard.view0.subviews[0] as! DashBoardElement).isLandscape = isLandscape
        (viewDashboard.view1.subviews[0] as! DashBoardElement).isLandscape = isLandscape
        (viewDashboard.view2.subviews[0] as! DashBoardElement).isLandscape = isLandscape
        (viewDashboard.view3.subviews[0] as! DashBoardElement).isLandscape = isLandscape
        (viewDashboard.view4.subviews[0] as! DashBoardElement).isLandscape = isLandscape
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
        if plan != nil {
            showCloseButton()
        }
        showPowerSaveOn(isShow: false)
    }
    
    private func showPowerSaveOn(isShow: Bool) {
        var menuItem: [UIBarButtonItem] = [btnPowerSaveOff]
        if isShow {
            menuItem = [btnPowerSaveOn]
        }
        
        if let parent = self.parent as? TrainingViewController {
            if parent.trainingEnvType == TrainingEnvironmentType.ergometer {
                menuItem.append(parent.bluetoothTabBarItem)
            }
        }
        self.navigationItem.setRightBarButtonItems(menuItem, animated: true)
    }
    
    private lazy var mainStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    private lazy var viewDashboard: DashboardView! = {
        let view = DashboardView()
        
        return view
    }()
    
    private lazy var viewDashboardPlan: DashboardPlanView! = {
        let view = DashboardPlanView()
        
        return view
    }()
    
    private lazy var buttonView: UIView! = {
        let buttonView = UIView()
        buttonView.backgroundColor = Colors.colorPrimary
        
        return buttonView
    }()
    
    private lazy var btnPlaySmall: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_play_48dp")!, color: Colors.colorGreen)
        button.backgroundColor = Colors.colorGreen
        button.addTarget(self, action: #selector(btnPlayPauseClick), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var viewSwipePause: UIView! = {
        let view = UIView()
        view.layer.cornerRadius = 75 / 2
        
        view.addSubview(self.btnPause)
        
        view.backgroundColor = Colors.colorPauseBackground
        
        return view
    }()
    
    private lazy var btnPause: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_pause_white_48pt")!, color: Colors.colorAccent)
        button.layer.cornerRadius = 75 / 2
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(animateBtnPause(pan:))))
        
        return button
    }()
    
    private lazy var pauseView: UIView! = {
        let view = UIView()
        
        let btnPlay = RoundButton(radius: 125, image: UIImage(named: "ic_play_big")!, color: Colors.colorGreen)
        btnPlay.addTarget(self, action: #selector(btnPlayClick), for: .touchUpInside)
        
        let btnStop = RoundButton(radius: 125, image: UIImage(named: "ic_stop_big")!, color: Colors.colorRed)
        btnStop.addTarget(self, action: #selector(btnStopClick), for: .touchUpInside)
        
        let viewPlay = UIView()
        let viewStop = UIView()
        viewPlay.addSubview(btnPlay)
        btnPlay.snp.makeConstraints({ (make) in
            make.center.equalTo(viewPlay)
        })
        viewStop.addSubview(btnStop)
        btnStop.snp.makeConstraints({ (make) in
            make.center.equalTo(viewStop)
        })
        
        let viewSpace1 = UIView()
        let viewSpace2 = UIView()
        let viewSpace3 = UIView()
        
        self.pauseStackView.addArrangedSubview(viewSpace1)
        self.pauseStackView.addArrangedSubview(viewPlay)
        self.pauseStackView.addArrangedSubview(viewSpace2)
        self.pauseStackView.addArrangedSubview(viewStop)
        self.pauseStackView.addArrangedSubview(viewSpace3)
        
        view.addBlurEffect()
        
        view.addSubview(self.pauseStackView)
        self.pauseStackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        view.isHidden = true
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            if let window:UIWindow = applicationDelegate.window {
                
                view.frame = UIScreen.main.bounds
                
                let blueView:UIView = UIView(frame: UIScreen.main.bounds)
                window.addSubview(view)
            }
        }
        
        return view
    }()
    
    private lazy var pauseStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var btnPowerSaveOn: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "powerSavingModeActive")?.withRenderingMode(.alwaysOriginal)
        button.target = self
        button.action = #selector(clickPowerSaveOff)
        
        return button
    }()
    
    private lazy var btnPowerSaveOff: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "powerSavingMode")?.withRenderingMode(.alwaysOriginal)
        button.target = self
        button.action = #selector(clickPowerSaveOn)
        
        return button
    }()
    
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
            
            if isLandscape {
                let diffYGlobal = pan.view!.center.y + translation.y
                diffY = diffYGlobal < btnPauseOriginalY ? diffYGlobal : btnPauseOriginalY
                swipe = btnPauseOriginalY - diffY
            } else {
                let diffXGlobal = pan.view!.center.x + translation.x
                diffX = diffXGlobal > btnPauseOriginalX ? diffXGlobal : btnPauseOriginalX
                swipe = abs(btnPauseOriginalX - diffX)
            }
            
            if swipe > (swipeArea - 75) {
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
            self.btnPause.center = CGPoint(x: self.btnPauseOriginalX, y: self.btnPauseOriginalY)
        })
    }
}
