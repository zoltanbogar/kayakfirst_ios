//
//  VcPlanListLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 28..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcPlanListLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(etSearch)
        etSearch.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(margin2)
            make.right.equalTo(contentView).offset(-margin2)
            make.top.equalTo(contentView).offset(margin)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(tableViewPlan)
        tableViewPlan.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.top.equalTo(etSearch.snp.bottom).offset(margin)
        }
        
        contentView.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: views
    lazy var tableViewPlan: PlanTableView! = {
        let tableViewPlan = PlanTableView(view: self.contentView)
        
        return tableViewPlan
    }()
    
    lazy var etSearch: SearchTextView! = {
        let view = SearchTextView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    lazy var progressBar: UIActivityIndicatorView! = {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: buttonHeight, height: buttonHeight))
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = Colors.colorWhite
        
        return spinner
    }()
    
    //MARK: BarButton items
    lazy var btnAdd: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "ic_add_white")
        
        return button
    }()
    
}
