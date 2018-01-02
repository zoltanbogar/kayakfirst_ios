//
//  PlanTypeView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 14..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

protocol PlanTypeSelectListener {
    func timeSelected()
    func distanceSelected()
}

class PlanTypeView: CustomUi<ViewPlanTypeLayout> {
    
    //MARK: properties
    var planTypeSelectListener: PlanTypeSelectListener?
    
    //MARK: init view
    override func initView() {
        super.initView()
        
        contentLayout!.viewTime.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickTime)))
        contentLayout!.viewDistance.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickDistance)))
    }
    
    override func getContentLayout(contentView: UIView) -> ViewPlanTypeLayout {
        return ViewPlanTypeLayout(contentView: contentView)
    }
    
    //MARK: lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentLayout?.initTextHeight(frame: self.frame)
    }
    
    //MARK: button listener
    @objc private func clickTime() {
        if let listener = planTypeSelectListener {
            listener.timeSelected()
        }
    }
    
    @objc private func clickDistance() {
        if let listener = planTypeSelectListener {
            listener.distanceSelected()
        }
    }
    
}
