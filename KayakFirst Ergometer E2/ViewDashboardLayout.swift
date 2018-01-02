//
//  ViewDashboardLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewDashboardLayout: BaseLayout {
    
    override func setView() {
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
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
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
