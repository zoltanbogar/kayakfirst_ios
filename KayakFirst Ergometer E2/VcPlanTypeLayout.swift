//
//  VcPlanTypeLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 28..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcPlanTypeLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(viewPlanType)
        viewPlanType.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    //MARK: views
    lazy var viewPlanType: PlanTypeView! = {
        let view = PlanTypeView()
        
        return view
    }()
}
