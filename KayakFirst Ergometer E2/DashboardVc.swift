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
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.viewSwipePause.delegate = self
        contentLayout!.btnPlaySmall.addTarget(self, action: #selector(btnPlayClick), for: .touchUpInside)
        
        /*contentLayout!.btnPlaySmall.addTarget(self, action: #selector(btnPlayPauseClick), for: .touchUpInside)
        contentLayout!.btnPause.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(animateBtnPause(pan:))))
        contentLayout!.btnPlay.addTarget(self, action: #selector(btnPlayClick), for: .touchUpInside)
        contentLayout!.btnStop.addTarget(self, action: #selector(btnStopClick), for: .touchUpInside)
        
        contentLayout!.btnPowerSaveOn.target = self
        contentLayout!.btnPowerSaveOn.action = #selector(clickPowerSaveOff)
        contentLayout!.btnPowerSaveOff.target = self
        contentLayout!.btnPowerSaveOff.action = #selector(clickPowerSaveOn)*/
    }
    
    override func getContentLayout(contentView: UIView) -> VcDashobardLayout {
        return VcDashobardLayout(contentView: contentView, dashboardLayoutDict: dashboardLayoutDict, plan: plan)
    }
    
    override func initTabBarItems() {
        showCustomBackButton()
        showLogoCenter(viewController: self)
        
        handleBluetoothMenu(barButtons: nil)
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
    
    //MARK: delegate
    func onPauseCLicked() {
        getTrainingVc().pauseClick()
    }
    
    //MARK: callbacks
    @objc func btnPlayClick() {
        getTrainingVc().playClick()
    }
    
}
