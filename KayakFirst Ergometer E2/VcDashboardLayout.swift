//
//  VcDashboardLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 29..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcDashobardLayout: BaseLayout {
    
    var isLandscape = false
    
    private let dashboardLayoutDict: [Int:Int]
    private let plan: Plan?
    
    var dashboardElement0: DashBoardElement?
    var dashboardElement1: DashBoardElement?
    var dashboardElement2: DashBoardElement?
    var dashboardElement3: DashBoardElement?
    var dashboardElement4: DashBoardElement?
    
    init(contentView: UIView, dashboardLayoutDict: [Int:Int], plan: Plan?) {
        self.dashboardLayoutDict = dashboardLayoutDict
        self.plan = plan
        
        super.init(contentView: contentView)
    }
    
    override func setView() {
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
            make.width.equalTo(dashboardPauseSwipeArea)
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
            make.height.equalTo(dashboardPauseSwipeArea)
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
    
    private func initDashboardViews() {
        var viewToShow: UIView = viewDashboard
        
        for (position, tag) in dashboardLayoutDict {
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
        
        if plan != nil {
            viewToShow = viewDashboardPlan
            setPlantoPlanView()
        }
        
        mainStackView.addArrangedSubview(viewToShow)
    }
    
    func setPlantoPlanView() {
        viewDashboardPlan.plan = plan
    }
    
    //MARK: views
    lazy var mainStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.spacing = dashboardDividerWidth
        
        return stackView
    }()
    
    lazy var viewDashboard: DashboardView! = {
        let view = DashboardView()
        
        return view
    }()
    
    lazy var viewDashboardPlan: DashboardPlanView! = {
        let view = DashboardPlanView()
        
        return view
    }()
    
    lazy var buttonView: UIView! = {
        let buttonView = UIView()
        buttonView.backgroundColor = Colors.colorPrimary
        
        return buttonView
    }()
    
    lazy var btnPlaySmall: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_play_48dp")!, color: Colors.colorGreen)
        button.backgroundColor = Colors.colorGreen
        
        return button
    }()
    
    lazy var viewSwipePause: UIView! = {
        let view = UIView()
        view.layer.cornerRadius = 75 / 2
        
        view.addSubview(self.btnPause)
        
        view.backgroundColor = Colors.colorPauseBackground
        
        return view
    }()
    
    lazy var btnPause: RoundButton! = {
        let button = RoundButton(radius: 75, image: UIImage(named: "ic_pause_white_48pt")!, color: Colors.colorAccent)
        button.layer.cornerRadius = 75 / 2
        
        return button
    }()
    
    lazy var pauseView: UIView! = {
        let view = UIView()
        
        let viewPlay = UIView()
        let viewStop = UIView()
        viewPlay.addSubview(self.btnPlay)
        self.btnPlay.snp.makeConstraints({ (make) in
            make.center.equalTo(viewPlay)
        })
        viewStop.addSubview(self.btnStop)
        self.btnStop.snp.makeConstraints({ (make) in
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
    
    lazy var btnPlay: RoundButton! = {
        let btnPlay = RoundButton(radius: 125, image: UIImage(named: "ic_play_big")!, color: Colors.colorGreen)
        
        return btnPlay
    }()
    
    lazy var btnStop: RoundButton! = {
        let btnStop = RoundButton(radius: 125, image: UIImage(named: "ic_stop_big")!, color: Colors.colorRed)
        
        return btnStop
    }()
    
    lazy var pauseStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    //MARK: BarButton items
    lazy var btnPowerSaveOn: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "powerSavingModeActive")?.withRenderingMode(.alwaysOriginal)
        
        return button
    }()
    
    lazy var btnPowerSaveOff: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "powerSavingMode")?.withRenderingMode(.alwaysOriginal)
        
        return button
    }()
    
}
