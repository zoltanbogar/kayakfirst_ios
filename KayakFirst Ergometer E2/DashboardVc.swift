//
//  DashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashboardVc: BaseVC, CycleStateChangeListener {
    
    //MARK: properties
    private let telemetry = Telemetry.sharedInstance
    private var dashboardElement0: DashBoardElement?
    private var dashboardElement1: DashBoardElement?
    private var dashboardElement2: DashBoardElement?
    private var dashboardElement3: DashBoardElement?
    private var dashboardElement4: DashBoardElement?
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        telemetry.addCycleStateChangeListener(cycleStateChangeListener: self)
    }
    
    //MARK: button listeners
    @objc private func btnPlayPauseClick() {
        if let parent = self.parent as? TrainingViewController {
            if telemetry.cycleState == CycleState.resumed {
                parent.onPauseClicked()
            } else {
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
            switch newCycleState {
            case CycleState.idle:
                self.showPauseView(false)
                self.initBtnPlayPause(isPlay: true, isShow: true)
                self.showBackButton(true)
                self.refreshDashboardElements(false)
            case CycleState.stopped:
                self.showPauseView(false)
                self.initBtnPlayPause(isPlay: true, isShow: true)
                self.showBackButton(true)
                self.refreshDashboardElements(false)
            case CycleState.paused:
                self.showPauseView(true)
                self.initBtnPlayPause(isPlay: true, isShow: false)
                self.showBackButton(false)
                self.refreshDashboardElements(false)
            case CycleState.resumed:
                self.showPauseView(false)
                self.initBtnPlayPause(isPlay: false, isShow: true)
                self.showBackButton(false)
                self.refreshDashboardElements(true)
            default: break
            }
        }
    }
    
    private func showPauseView(_ isShow: Bool) {
        pauseView.isHidden = !isShow
    }
    
    private func initBtnPlayPause(isPlay: Bool, isShow: Bool) {
        if isPlay {
            btnPlayPause.image = UIImage(named: "ic_play_48dp")!
        } else {
            btnPlayPause.image = UIImage(named: "ic_pause_white_48pt")!
        }
        
        btnPlayPause.isHidden = !isShow
    }
    
    private func showBackButton(_ isShow: Bool) {
        self.navigationItem.setHidesBackButton(!isShow, animated: true)
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
        stackView1.distribution = .fillEqually
        stackView1.spacing = dashboardDividerWidth
        
        stackView1.addArrangedSubview(view1)
        stackView1.addArrangedSubview(view2)
        
        let stackView2 = UIStackView()
        stackView2.axis = .horizontal
        stackView2.distribution = .fillEqually
        stackView2.spacing = dashboardDividerWidth
        
        stackView2.addArrangedSubview(view3)
        stackView2.addArrangedSubview(view4)
        
        stackView.addArrangedSubview(stackView1)
        stackView.addArrangedSubview(stackView2)
        
        buttonView.addSubview(btnPlayPause)
        btnPlayPause.snp.makeConstraints { make in
            make.center.equalTo(buttonView)
        }
        
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
    
    override func handlePortraitLayout() {
        mainStackView.axis = .vertical
        pauseStackView.axis = .vertical
        
        buttonView.snp.removeConstraints()
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(mainStackView)
        }
    }
    
    override func handleLandscapeLayout() {
        mainStackView.axis = .horizontal
        pauseStackView.axis = .horizontal
        
        buttonView.snp.removeConstraints()
        buttonView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(mainStackView)
        }
    }
    
    override func initTabBarItems() {
        self.navigationItem.setRightBarButtonItems(nil, animated: true)
    }
    
    private lazy var mainStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    private lazy var view0: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.red
        
        return view
    }()
    
    private lazy var view1: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.blue
        
        return view
    }()
    
    private lazy var view2: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.yellow
        
        return view
    }()
    
    private lazy var view3: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.green
        
        return view
    }()
    
    private lazy var view4: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.orange
        
        return view
    }()
    
    private lazy var buttonView: UIView! = {
        let buttonView = UIView()
        buttonView.backgroundColor = Colors.colorPrimary
        
        return buttonView
    }()
    
    private lazy var btnPlayPause: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_play_48dp")!, color: Colors.colorGreen)
        
        button.addTarget(self, action: #selector(btnPlayPauseClick), for: .touchUpInside)
        
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
    
}
