//
//  VcDashboardLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 29..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcDashobardLayout: BaseLayout {
    
    private let buttonViewWidth: CGFloat = 100
    
    private let dashboardLayoutDict: [Int:Int]?
    private let plan: Plan?
    
    init(contentView: UIView, dashboardLayoutDict: [Int:Int]?, plan: Plan?) {
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
        super.handlePortraitLayout(size: size)
        mainStackView.axis = .vertical
        
        buttonView.snp.removeConstraints()
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(buttonViewWidth)
            make.width.equalTo(mainStackView)
        }
        
        viewSwipePause.contentLayout?.handlePortraitLayout(size: size)
        viewSwipePause.snp.removeConstraints()
        viewSwipePause.snp.makeConstraints { (make) in
            make.center.equalTo(buttonView)
            make.width.equalTo(pauseViewSwipeArea)
            make.height.equalTo(pauseViewHeight)
        }
        
        if dashboardLayoutDict != nil {
             viewDashboard.contentLayout!.handlePortraitLayout(size: size)
        }
        if plan != nil {
            viewDashboardPlan.contentLayout!.handlePortraitLayout(size: size)
        }
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        super.handleLandscapeLayout(size: size)
        mainStackView.axis = .horizontal
        
        buttonView.snp.removeConstraints()
        buttonView.snp.makeConstraints { make in
            make.width.equalTo(buttonViewWidth)
            make.height.equalTo(mainStackView)
        }
        
        viewSwipePause.contentLayout?.handleLandscapeLayout(size: size)
        viewSwipePause.snp.removeConstraints()
        viewSwipePause.snp.makeConstraints { (make) in
            make.center.equalTo(buttonView)
            make.width.equalTo(pauseViewHeight)
            make.height.equalTo(pauseViewSwipeArea)
        }
        if dashboardLayoutDict != nil {
            viewDashboard.contentLayout!.handleLandscapeLayout(size: size)
        }
        if plan != nil {
            viewDashboardPlan.contentLayout!.handleLandscapeLayout(size: size)
        }
    }
    
    private func initDashboardViews() {
        var viewToShow: UIView = viewDashboard
        
        if let dashobardLayoutDictValue = dashboardLayoutDict {
            viewDashboard.setDashboardLayoutDict(dashboardLayoutDict: dashobardLayoutDictValue)
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
    
    lazy var viewSwipePause: SwipePauseView! = {
        let view = SwipePauseView()
        
        view.isHidden = true
        
        return view
    }()
    
    //MARK: BarButton items
    lazy var btnPowerSaveOff: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        
        button.image = UIImage(named: "powerSavingMode")
        
        button.tintColor = Colors.colorBatterySaverInactive
        
        return button
    }()
    
}
