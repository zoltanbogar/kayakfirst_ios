//
//  DashboardView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DashboardView: RefreshView<ViewDashboardLayout> {
    
    func setDashboardLayoutDict(dashboardLayoutDict: [Int:Int]?) {
        if let dashobardLayoutDictValue = dashboardLayoutDict {
            for (position, tag) in dashobardLayoutDictValue {
                let dashboardElement = DashBoardElement.getDashBoardElementByTag(tag: tag, isValueVisible: true)
                var view: UIView?
                switch position {
                case 0:
                    view = contentLayout!.view0
                    contentLayout!.dashboardElement0 = dashboardElement
                case 1:
                    view = contentLayout!.view1
                    contentLayout!.dashboardElement1 = dashboardElement
                case 2:
                    view = contentLayout!.view2
                    contentLayout!.dashboardElement2 = dashboardElement
                case 3:
                    view = contentLayout!.view3
                    contentLayout!.dashboardElement3 = dashboardElement
                case 4:
                    view = contentLayout!.view4
                    contentLayout!.dashboardElement4 = dashboardElement
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
    
    override func refreshUi() {
        contentLayout!.dashboardElement0?.refreshUi()
        contentLayout!.dashboardElement1?.refreshUi()
        contentLayout!.dashboardElement2?.refreshUi()
        contentLayout!.dashboardElement3?.refreshUi()
        contentLayout!.dashboardElement4?.refreshUi()
    }
    
    override func getContentLayout(contentView: UIView) -> ViewDashboardLayout {
        return ViewDashboardLayout(contentView: contentView)
    }
    
}
