//
//  PlanningTypeVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class PlanOrNotPlanVc: BaseVC {
    
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
        
        let planStackView = UIStackView()
        planStackView.axis = .horizontal
        
        planStackView.addArrangedSubview(viewTime)
        
        let halfDivider = HalfDivider()
        planStackView.addArrangedSubview(halfDivider)
        
        planStackView.addArrangedSubview(viewDistance)
        mainstackView.addArrangedSubview(planStackView)
        
        viewTime.snp.makeConstraints { (make) in
            make.width.equalTo(viewDistance)
        }
        
        viewRun.snp.makeConstraints { (make) in
            make.height.equalTo(planStackView)
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
    
    private lazy var viewTime: UIView! = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickTime)))
        
        let label = BebasUILabel()
        label.text = getString("plan_plan")
        label.textAlignment = .center
        label.font = label.font.withSize(56)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "durationIcon")
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.center.equalTo(view).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
        })
        view.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.top.equalTo(view.snp.top).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
            make.centerX.equalTo(view.snp.centerX)
        })
        
        return view
    }()
    
    private lazy var viewDistance: UIView! = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickDistance)))
        
        let label = BebasUILabel()
        label.text = getString("plan_plan")
        label.textAlignment = .center
        label.font = label.font.withSize(56)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "distanceIcon")
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.center.equalTo(view).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
        })
        view.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.top.equalTo(view.snp.top).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
            make.centerX.equalTo(view.snp.centerX)
        })
        
        return view
    }()
    
    //MARK: button listeners
    @objc private func clickRun() {
        show(MainVc(), sender: self)
    }
    
    @objc private func clickTime() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.time)
    }
    
    @objc private func clickDistance() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.distance)
    }
}
