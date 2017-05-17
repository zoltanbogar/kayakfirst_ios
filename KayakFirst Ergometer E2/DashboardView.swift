//
//  DashboardView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 17..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class DashboardView: UIView {
    
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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = dashboardDividerWidth
        
        stackView.addArrangedSubview(view0)
        
        let stackView1 = UIStackView()
        stackView1.axis = .horizontal
        stackView1.addArrangedSubview(view1)
        let halfDivider1 = HalfDivider()
        stackView1.addArrangedSubview(halfDivider1)
        stackView1.addArrangedSubview(view2)
        view1.snp.makeConstraints { (make) in
            make.width.equalTo(view2)
        }
        halfDivider1.snp.makeConstraints { (make) in
            make.width.equalTo(dashboardDividerWidth)
        }
        
        let stackView2 = UIStackView()
        stackView2.axis = .horizontal
        stackView2.addArrangedSubview(view3)
        let halfDivider2 = HalfDivider()
        stackView2.addArrangedSubview(halfDivider2)
        stackView2.addArrangedSubview(view4)
        view3.snp.makeConstraints { (make) in
            make.width.equalTo(view4)
        }
        halfDivider2.snp.makeConstraints { (make) in
            make.width.equalTo(dashboardDividerWidth)
        }
        
        stackView.addArrangedSubview(stackView1)
        stackView.addArrangedSubview(stackView2)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    //MARK: views
    lazy var view0: UIView! = {
        let view = UIView()
        
        return view
    }()
    
    lazy var view1: UIView! = {
        let view = UIView()
        
        return view
    }()
    
    lazy var view2: UIView! = {
        let view = UIView()
        
        return view
    }()
    
    lazy var view3: UIView! = {
        let view = UIView()
        
        return view
    }()
    
    lazy var view4: UIView! = {
        let view = UIView()
        
        return view
    }()
}
