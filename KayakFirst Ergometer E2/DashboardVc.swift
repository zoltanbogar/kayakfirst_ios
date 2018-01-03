//
//  DashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 03..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DashboardVc: BaseTrainingVc<VcDashobardLayout> {
    
    //MARK: properties
    var dashboardLayoutDict: [Int : Int]?
    var plan: Plan?
    
    //MARK: init view
    override func initView() {
        super.initView()
        
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
    
}
