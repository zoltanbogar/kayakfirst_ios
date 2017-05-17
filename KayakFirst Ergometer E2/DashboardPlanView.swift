//
//  DashboardPlanView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DashboardPlanView: UIView {
    
    //MARK: properties
    var plan: Plan?
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: init views
    private func initView() {
        //TODO
    }
    
}
