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
    private var dragDropHelper: DragDropHelper!
    
    //MARK: views
    override func initView() {
        super.initView()
        
        contentLayout?.btnDone.target = self
        contentLayout?.btnDone.action = #selector(btnDoneClick)
        
        dragDropHelper = DragDropHelper(contentLayout: contentLayout!)
    }
    
    override func getContentLayout(contentView: UIView) -> VcSetDashboardLayout {
        return VcSetDashboardLayout(contentView: contentView, showPullForceLayout: getTrainingEnvType() == TrainingEnvironmentType.ergometer)
    }
    
    override func initTabBarItems() {
        let buttons: [UIBarButtonItem] = [contentLayout!.btnDone]
        
        handleBluetoothMenu(barButtons: buttons)
        
        showLogoOnLeft()
        
        self.title = getString("navigation_set_dashboard")
    }
    
    //MARK: button listeners
    @objc private func btnDoneClick() {
        if let parent = self.parent as? TrainingViewControllerOld {
            parent.showDashboard()
        }
    }
    
    override func backClick(sender: UIBarButtonItem) {
        if let parent = self.parent as? TrainingViewControllerOld {
            parent.closeViewController(shoudlCloseParents: false)
        }
    }
}
