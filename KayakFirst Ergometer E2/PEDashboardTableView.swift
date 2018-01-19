//
//  PEDashboardTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PEDashboardTableView: TableViewWithEmpty<PlanElement> {
    
    private var showPosition: Int = 0
    
    //MARK: init
    override init(view: UIView) {
        super.init(view: view)
        
        backgroundColor = Colors.colorTransparent
        separatorColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func getEmptyView() -> UIView {
        return labelEmpty
    }
    
    override func getCellClass() -> AnyClass {
        return PlanElementDetailsCell.self
    }
    
    //MARK: views
    private lazy var labelEmpty: UILabel! = {
        let label = AppUILabel()
        label.text = getString("plan_end")
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        
        return label
    }()
    
}
