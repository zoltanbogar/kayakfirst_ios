//
//  VcDashboardLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 29..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcDashobardLayout: BaseLayout {
    
    private let dashboardLayoutDict: [Int:Int]?
    private let plan: Plan?
    
    var dashboardElement0: DashBoardElement?
    var dashboardElement1: DashBoardElement?
    var dashboardElement2: DashBoardElement?
    var dashboardElement3: DashBoardElement?
    var dashboardElement4: DashBoardElement?
    
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
            make.height.equalTo(100)
            make.width.equalTo(mainStackView)
        }
        
        viewSwipePause.snp.removeConstraints()
        viewSwipePause.snp.makeConstraints { (make) in
            make.center.equalTo(buttonView)
        }
        
        setDashboardElementsOrientation()
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        super.handleLandscapeLayout(size: size)
        mainStackView.axis = .horizontal
        
        buttonView.snp.removeConstraints()
        buttonView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(mainStackView)
        }
        
        viewSwipePause.snp.removeConstraints()
        viewSwipePause.snp.makeConstraints { (make) in
            make.center.equalTo(buttonView)
        }
        
        setDashboardElementsOrientation()
    }
    
    private func setDashboardElementsOrientation() {
        if plan == nil {
            (viewDashboard.contentLayout!.view0.subviews[0] as! DashBoardElement).isLandscape = isLandscape
            (viewDashboard.contentLayout!.view1.subviews[0] as! DashBoardElement).isLandscape = isLandscape
            (viewDashboard.contentLayout!.view2.subviews[0] as! DashBoardElement).isLandscape = isLandscape
            (viewDashboard.contentLayout!.view3.subviews[0] as! DashBoardElement).isLandscape = isLandscape
            (viewDashboard.contentLayout!.view4.subviews[0] as! DashBoardElement).isLandscape = isLandscape
        }
    }
    
    private func initDashboardViews() {
        var viewToShow: UIView = viewDashboard
        
        if let dashobardLayoutDictValue = dashboardLayoutDict {
            for (position, tag) in dashobardLayoutDictValue {
                let dashboardElement = DashBoardElement.getDashBoardElementByTag(tag: tag, isValueVisible: true)
                var view: UIView?
                switch position {
                case 0:
                    view = viewDashboard.contentLayout!.view0
                    dashboardElement0 = dashboardElement
                case 1:
                    view = viewDashboard.contentLayout!.view1
                    dashboardElement1 = dashboardElement
                case 2:
                    view = viewDashboard.contentLayout!.view2
                    dashboardElement2 = dashboardElement
                case 3:
                    view = viewDashboard.contentLayout!.view3
                    dashboardElement3 = dashboardElement
                case 4:
                    view = viewDashboard.contentLayout!.view4
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
