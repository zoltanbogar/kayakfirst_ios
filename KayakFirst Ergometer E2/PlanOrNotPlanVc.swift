//
//  PlanningTypeVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class PlanOrNotPlanVc: BaseVC, PlanTypeSelectListener {
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadMessage()
    }
    
    //MARK: button listeners
    @objc private func clickRun() {
        show(MainVc(), sender: self)
    }
    
    //MARK: protocol
    func timeSelected() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.time)
    }
    
    func distanceSelected() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.distance)
    }
    
    //MARK: initView
    override func initView() {
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
        
        showLogoCenter(viewController: self)
    }
    
    //MARK: views
    private lazy var viewRun: UIView! = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickRun)))
        
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
    
    private lazy var planTypeView: PlanTypeView! = {
        let view = PlanTypeView()
        
        view.planTypeSelectListener = self
        
        return view
    }()
}
