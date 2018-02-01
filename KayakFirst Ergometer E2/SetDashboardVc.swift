//
//  SetDashboardVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class SetDashboardVc: BaseTrainingVc<VcSetDashboardLayout> {
    
    //MARK: properties
    private var dragDropHelper: DragDropDashboardHelper!
    
    //MARK: views
    override func initView() {
        super.initView()
        
        contentLayout?.btnDone.target = self
        contentLayout?.btnDone.action = #selector(btnDoneClick)
        
        dragDropHelper = DragDropDashboardHelper(contentLayout: contentLayout!)
    }
    
    override func getContentLayout(contentView: UIView) -> VcSetDashboardLayout {
        return VcSetDashboardLayout(contentView: contentView, showPullForceLayout: getTrainingEnvType() == TrainingEnvironmentType.ergometer)
    }
    
    override func initTabBarItems() {
        let buttons: [UIBarButtonItem] = [contentLayout!.btnDone]
        
        handleBluetoothMenu(barButtons: buttons, badGpsTabBarItem: nil)
        
        showCloseButton()
        
        showLogoOnLeft()
        
        self.title = getString("navigation_set_dashboard")
    }
    
    //MARK: button listeners
    @objc private func btnDoneClick() {
        getTrainingVc().showDashboardVc(dashboardLayoutDict: dragDropHelper.dashboardLayoutDict)
    }
    
}
