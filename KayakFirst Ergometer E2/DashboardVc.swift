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
    }
    
    override func getContentLayout(contentView: UIView) -> VcDashobardLayout {
        return VcDashobardLayout(contentView: contentView, dashboardLayoutDict: dashboardLayoutDict, plan: plan)
    }
    
    override func initTabBarItems() {
        if plan == nil {
            showCustomBackButton()
        } else {
            showCloseButton()
        }

        showLogoCenter(viewController: self)
        
        let menuItem: [UIBarButtonItem] = [contentLayout!.btnPowerSaveOff]
        
        handleBluetoothMenu(barButtons: menuItem)
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
        
        contentLayout!.btnPlaySmall.image = image
        contentLayout!.btnPlaySmall.isHidden = !isShow
    }
    
    func refreshDashboardElements(_ isRefresh: Bool) {
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
    
    func resetPlanDashboardView() {
        if plan != nil {
            contentLayout!.viewDashboardPlan.resetPlan()
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
    
}
