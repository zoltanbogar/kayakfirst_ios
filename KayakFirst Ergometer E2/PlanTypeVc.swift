//
//  PlanTypeVc.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 08..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanTypeVc: BaseVC {
    
    //MARK: button listeners
    @objc private func clickTime() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.time)
    }
    
    @objc private func clickDistance() {
        startPlanListVc(navigationController: self.navigationController!, planType: PlanType.distance)
    }
    
    //MARK: inint views
    override func initView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(viewTime)
        
        let halfDivider = HalfDivider()
        stackView.addArrangedSubview(halfDivider)
        
        stackView.addArrangedSubview(viewDistance)
        
        viewTime.snp.makeConstraints { (make) in
            make.width.equalTo(viewDistance)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    override func initTabBarItems() {
        showLogoCenter(viewController: self)
    }
    
    //MARK: views
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
            make.bottom.equalTo(imageView.snp.top).inset(UIEdgeInsetsMake(0, 0, margin2, 0))
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
             make.bottom.equalTo(imageView.snp.top).inset(UIEdgeInsetsMake(0, 0, margin2, 0))
            make.centerX.equalTo(view.snp.centerX)
        })
        
        return view
    }()
    
}
