//
//  DashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DashboardVc: BaseTrainingVc<VcDashobardLayout>, SwipePauseViewDelegate {
    
    //MARK: properties
    var dashboardLayoutDict: [Int : Int]?
    var plan: Plan?
    
    var isPlanDone: Bool {
        get {
            return contentLayout!.viewDashboardPlan.isDone
        }
    }
    
    //MARK: lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentLayout!.viewDashboardPlan.viewDidLayoutSubViews()
    }
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.viewSwipePause.delegate = self
        contentLayout!.btnPlaySmall.addTarget(self, action: #selector(btnPlayClick), for: .touchUpInside)
        
        getTrainingVc().initBatterySaveHelper()
        getTrainingVc().planSoundHelper = contentLayout!.viewDashboardPlan.planSoundHelper
        
        refreshUi()
    }
    
    override func getContentLayout(contentView: UIView) -> VcDashobardLayout {
        return VcDashobardLayout(contentView: contentView, dashboardLayoutDict: dashboardLayoutDict, plan: plan)
    }
    
    override func handlePortraitLayout(size: CGSize) {
        super.handlePortraitLayout(size: size)
        
        getTrainingVc().handlePortraitLayout()
    }
    
    override func handleLandscapeLayout(size: CGSize) {
        super.handleLandscapeLayout(size: size)
        
        getTrainingVc().handleLandscapeLayout()
    }
    
    override func initTabBarItems() {
        if plan == nil {
            showCustomBackButton()
        } else {
            showCloseButton()
        }

        showLogoCenter(viewController: self)
        
        let menuItem: [UIBarButtonItem] = [contentLayout!.btnPowerSaveOff]
        
        handleBluetoothMenu(barButtons: menuItem, badGpsTabBarItem: badGpsTabBarItem)
    }
    
    func showBadGpsLayout(isShow: Bool) {
        var color: UIColor
        
        if isShow {
            color = UIColor.black
        } else {
            color = Colors.colorTransparent
        }
        
        badGpsTabBarItem.tintColor = color
    }
    
    //MARK: functions
    func showViewSwipePause(isShow: Bool) {
        contentLayout!.viewSwipePause.isHidden = !isShow
    }
    
    func initBtnPlaySmall(showRestart: Bool, isShow: Bool) {
        var image: UIImage = UIImage(named: "ic_play_48dp")!
        
        if showRestart {
            image = UIImage(named: "ic_refresh_white_48pt")!
        }
        
        contentLayout?.btnPlaySmall.image = image
        contentLayout?.btnPlaySmall.isHidden = !isShow
    }
    
    func refreshUi() {
        if plan != nil {
            contentLayout!.viewDashboardPlan.refreshUi()
        } else {
            contentLayout!.viewDashboard.refreshUi()
        }
    }
    
    //MARK: delegate
    func onPauseCLicked() {
        getTrainingVc().pauseClick()
    }
    
    //MARK: callbacks
    @objc func btnPlayClick() {
        getTrainingVc().playClick()
    }
    
    //MARK: views
    lazy var badGpsTabBarItem: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "bad_gps")
        
        button.tintColor = Colors.colorTransparent
        
        return button
    }()
    
}
