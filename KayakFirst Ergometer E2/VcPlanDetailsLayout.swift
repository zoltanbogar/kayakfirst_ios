//
//  VcPlanDetailsLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 12. 28..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class VcPlanDetailsLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(planDetailsTableView)
        planDetailsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    //MARK: BarButtonItems
    lazy var planDetailsTableView: PlanDetailsTableView! = {
        let view = PlanDetailsTableView(view: self.contentView)
        
        return view
    }()
    
    lazy var btnSave: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "save")
        
        return button
    }()
    
    lazy var btnDelete: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "trash")
        
        return button
    }()
    
    lazy var btnEdit: UIBarButtonItem! = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "edit")
        
        return button
    }()
    
}
