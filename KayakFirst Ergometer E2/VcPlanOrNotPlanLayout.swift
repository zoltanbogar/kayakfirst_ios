//
//  VcPlanOrNotPlanLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 28..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcPlanOrNotPlanLayout: BaseLayout {
    
    override func setView() {
        let mainstackView = UIStackView()
        mainstackView.axis = .vertical
        
        mainstackView.addArrangedSubview(viewRun)
        let dividerView = DividerView()
        mainstackView.addArrangedSubview(dividerView)
        dividerView.snp.makeConstraints { (make) in
            make.width.equalTo(mainstackView)
            make.height.equalTo(dashboardDividerWidth)
        }
        
        mainstackView.addArrangedSubview(planTypeView)
        
        viewRun.snp.makeConstraints { (make) in
            make.height.equalTo(planTypeView)
        }
        
        contentView.addSubview(mainstackView)
        mainstackView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    //MARK: views
    lazy var viewRun: UIView! = {
        let view = UIView()
        
        let label = BebasUILabel()
        label.text = getString("plan_run")
        label.textAlignment = .center
        label.font = label.font.withSize(75)
        
        view.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        
        return view
    }()
    
    lazy var planTypeView: PlanTypeView! = {
        let view = PlanTypeView()
        
        return view
    }()
    
}
