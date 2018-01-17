//
//  DashBoardElement.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class DashBoardElement: RefreshView<ViewDashboardElementLayout> {
    
    //MARK: properties
    internal let telemetry = Telemetry.sharedInstance
    var isSelected: Bool = false {
        didSet {
            contentLayout!.selectedView.isHidden = !isSelected
        }
    }
    var isValueVisible: Bool = true {
        didSet {
            contentLayout!.labelValue.isHidden = !isValueVisible
            contentLayout!.labelTitle.snp.makeConstraints { make in
                if isValueVisible {
                    make.top.equalTo(self).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
                    make.centerX.equalTo(self)
                    
                    if isMetric() {
                        contentLayout!.labelTitle.text = self.getTitleOneLineMetric().uppercased()
                    } else {
                        contentLayout!.labelTitle.text = self.getTitleOneLineImperial().uppercased()
                    }
                } else {
                    make.center.equalTo(self)
                    
                    if isMetric() {
                        contentLayout!.labelTitle.text = self.getTitleMetric().uppercased()
                    } else {
                        contentLayout!.labelTitle.text = self.getTitleImperial().uppercased()
                    }
                }
            }
        }
    }
    var isLandscape: Bool = false {
        didSet {
            if isLandscape {
                contentLayout!.initLandscape()
            } else {
                contentLayout!.initPortrait()
            }
        }
    }
    
    //MARK: init
    override init() {
        super.init()
        
        tag = getTagInt()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: views
    override func initView() {
        super.initView()
        
        if self.isMetric() {
            contentLayout!.labelTitle.text = self.getTitleMetric().uppercased()
        } else {
            contentLayout!.labelTitle.text = self.getTitleImperial().uppercased()
        }
        
    }
    
    override func getContentLayout(contentView: UIView) -> ViewDashboardElementLayout {
        return ViewDashboardElementLayout(contentView: contentView)
    }
    
    override func refreshUi() {
        contentLayout!.labelValue?.text = getFormattedText()
    }

    //MARK: abstract functions
    internal func getStringFormatter() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getFormattedText() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getValue() -> Double {
        fatalError("Must be implemented")
    }
    
    internal func getTitleMetric() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getTitleImperial() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getTitleOneLineMetric() -> String {
        fatalError("Must be implemented")
    }
    
    internal func getTitleOneLineImperial() -> String {
        fatalError("Must be implemented")
    }
    
    internal func isMetric() -> Bool {
        fatalError("Must be implemented")
    }
    
    internal func getTagInt() -> Int {
        fatalError("Must be implemented")
    }
    
    class func getDashBoardElementByTag(tag: Int, isValueVisible: Bool) -> DashBoardElement {
        var dashBoardelement: DashBoardElement
        
        switch tag {
        case DashBoardElement_Actual200.tagInt:
            dashBoardelement = DashBoardElement_Actual200()
        case DashBoardElement_Actual500.tagInt:
            dashBoardelement = DashBoardElement_Actual500()
        case DashBoardElement_Actual1000.tagInt:
            dashBoardelement = DashBoardElement_Actual1000()
        case DashBoardElement_Av200.tagInt:
            dashBoardelement = DashBoardElement_Av200()
        case DashBoardElement_Av500.tagInt:
            dashBoardelement = DashBoardElement_Av500()
        case DashBoardElement_Av1000.tagInt:
            dashBoardelement = DashBoardElement_Av1000()
        case DashBoardElement_AvPullForce.tagInt:
            dashBoardelement = DashBoardElement_AvPullForce()
        case DashBoardElement_AvSpeed.tagInt:
            dashBoardelement = DashBoardElement_AvSpeed()
        case DashBoardElement_AvStrokes.tagInt:
            dashBoardelement = DashBoardElement_AvStrokes()
        case DashBoardElement_CurrentSpeed.tagInt:
            dashBoardelement = DashBoardElement_CurrentSpeed()
        case DashBoardElement_Distance.tagInt:
            dashBoardelement = DashBoardElement_Distance()
        case DashBoardElement_Duration.tagInt:
            dashBoardelement = DashBoardElement_Duration()
        case DashBoardElement_PullForce.tagInt:
            dashBoardelement = DashBoardElement_PullForce()
        case DashBoardElement_Strokes.tagInt:
            dashBoardelement = DashBoardElement_Strokes()
        default:
            fatalError("Error in dashBoardelement tag")
        }
        dashBoardelement.isValueVisible = isValueVisible
        
        return dashBoardelement
    }
}
