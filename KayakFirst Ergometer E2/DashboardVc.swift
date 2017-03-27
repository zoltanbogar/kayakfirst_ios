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
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        telemetry.addCycleStateChangeListener(cycleStateChangeListener: self)
        onCycleStateChanged(newCycleState: telemetry.cycleState)
    }
    
    //MARK: button listeners
    @objc private func btnPlayPauseClick() {
        if let parent = self.parent as? TrainingViewController {
            if telemetry.cycleState == CycleState.resumed {
                parent.onPauseClicked()
            } else if telemetry.cycleState != CycleState.paused {
                parent.onPlayClicked()
            }
        }
    }
    
    @objc private func btnPlayClick() {
        if let parent = self.parent as? TrainingViewController {
            if telemetry.cycleState == CycleState.paused {
                parent.onCounterEnd()
            } else {
                parent.onPlayClicked()
            }
        }
    }
    
    @objc private func btnStopClick() {
        if let parent = self.parent as? TrainingViewController {
            parent.onStopClicked()
        }
    }
    
    //MARK: cycle state
    func onCycleStateChanged(newCycleState: CycleState) {
        DispatchQueue.main.async {
            self.showViewSwipePause(false)
            self.showPauseView(false)
            switch newCycleState {
            case CycleState.idle:
                self.initBtnPlaySmall(btnPlayPauseIcon: self.btnPlayState, isShow: true)
                self.refreshDashboardElements(false)
            case CycleState.stopped:
                self.initBtnPlaySmall(btnPlayPauseIcon: self.btnRestartState, isShow: true)
                self.refreshDashboardElements(false)
            case CycleState.paused:
                self.showPauseView(true)
                self.initBtnPlaySmall(btnPlayPauseIcon: self.btnRestartState, isShow: false)
                self.refreshDashboardElements(false)
            case CycleState.resumed:
                self.showViewSwipePause(true)
                self.initBtnPlaySmall(btnPlayPauseIcon: self.btnPlayState, isShow: false)
                self.refreshDashboardElements(true)
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
        switch telemetry.cycleState {
        case CycleState.idle:
            self.navigationItem.setHidesBackButton(false, animated: true)
            self.navigationItem.setLeftBarButtonItems(nil, animated: true)
        case CycleState.stopped:
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationItem.setLeftBarButtonItems([btnClose], animated: true)
        case CycleState.paused:
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationItem.setLeftBarButtonItems(nil, animated: true)
        case CycleState.resumed:
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationItem.setLeftBarButtonItems(nil, animated: true)
        default: break
        }
    }
    
    private func refreshDashboardElements(_ isRefresh: Bool) {
        dashboardElement0?.startRefresh(isRefresh)
        dashboardElement1?.startRefresh(isRefresh)
        dashboardElement2?.startRefresh(isRefresh)
        dashboardElement3?.startRefresh(isRefresh)
        dashboardElement4?.startRefresh(isRefresh)
    }
    
    //MARK: views
    override func initView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        stackView.addArrangedSubview(view0)
        
        let stackView1 = UIStackView()
        stackView1.axis = .horizontal
        stackView1.addArrangedSubview(view1)
        let halfDivider1 = HalfDivider()
        stackView1.addArrangedSubview(halfDivider1)
        stackView1.addArrangedSubview(view2)
        view1.snp.makeConstraints { (make) in
            make.width.equalTo(view2)
        }
        halfDivider1.snp.makeConstraints { (make) in
            make.width.equalTo(dashboardDividerWidth)
        }
        
        let stackView2 = UIStackView()
        stackView2.axis = .horizontal
        stackView2.addArrangedSubview(view3)
        let halfDivider2 = HalfDivider()
        stackView2.addArrangedSubview(halfDivider2)
        stackView2.addArrangedSubview(view4)
        view3.snp.makeConstraints { (make) in
            make.width.equalTo(view4)
        }
        halfDivider2.snp.makeConstraints { (make) in
            make.width.equalTo(dashboardDividerWidth)
        }
        
        stackView.addArrangedSubview(stackView1)
        stackView.addArrangedSubview(stackView2)
        
        
        buttonView.addSubview(viewSwipePause)
        
        buttonView.addSubview(btnPlaySmall)
        btnPlaySmall.snp.makeConstraints { make in
            make.center.equalTo(buttonView)
        }
        
        mainStackView.removeAllSubviews()
        mainStackView.addArrangedSubview(stackView)
        mainStackView.addArrangedSubview(buttonView)
        
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        initDashboardViews()
        contentView.backgroundColor = Colors.colorDashBoardDivider
        
        contentView.addSubview(pauseView)
        pauseView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    private func initDashboardViews() {
        if let parent = self.navigationController as? TrainingViewController {
            for (position, tag) in parent.dashboardLayoutDict {
                let dashboardElement = DashBoardElement.getDashBoardElementByTag(tag: tag, isValueVisible: true)
                var view: UIView?
                switch position {
                case 0:
                    view = view0
                    dashboardElement0 = dashboardElement
                case 1:
                    view = view1
                    dashboardElement1 = dashboardElement
                case 2:
                    view = view2
                    dashboardElement2 = dashboardElement
                case 3:
                    view = view3
                    dashboardElement3 = dashboardElement
                case 4:
                    view = view4
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
    }
    
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
        (view0.subviews[0] as! DashBoardElement).isLandscape = isLandscape
        (view1.subviews[0] as! DashBoardElement).isLandscape = isLandscape
        (view2.subviews[0] as! DashBoardElement).isLandscape = isLandscape
        (view3.subviews[0] as! DashBoardElement).isLandscape = isLandscape
        (view4.subviews[0] as! DashBoardElement).isLandscape = isLandscape
    }
    
    override func initTabBarItems() {
        showLogoOnRight()
    }
    
    private lazy var mainStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    private lazy var view0: UIView! = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var view1: UIView! = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var view2: UIView! = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var view3: UIView! = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var view4: UIView! = {
        let view = UIView()
        
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
        
        view.backgroundColor = Colors.colorGrey
        
        return view
    }()
    
    private lazy var btnPause: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_pause_white_48pt")!, color: Colors.colorYellow)
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
        
        self.pauseStackView.addArrangedSubview(viewPlay)
        self.pauseStackView.addArrangedSubview(viewStop)
        
        view.addBlurEffect()
        
        view.addSubview(self.pauseStackView)
        self.pauseStackView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        view.isHidden = true
        
        return view
    }()
    
    private lazy var pauseStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var btnClose: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_clear_white_24dp")
        button.target = self
        button.action = #selector(btnCloseClick)
        
        return button
    }()
    
    //MARK: button callbacks
    @objc private func btnCloseClick() {
        if let parent = self.parent as? TrainingViewController {
            parent.closeViewController()
        }
    }
    
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
