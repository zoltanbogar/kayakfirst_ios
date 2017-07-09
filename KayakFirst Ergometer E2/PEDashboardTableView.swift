//
//  PEDashboardTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PEDashboardTableView: TableViewWithEmpty<PlanElement> {
    
    //MARK: init
    override init(view: UIView) {
        super.init(view: view)
        
        //TODO: spacing between cells
        backgroundColor = Colors.colorTransparent
        separatorColor = Colors.colorTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: functions
    func removePlanElement(position: Int) {
        if dataList != nil && dataList!.count > position {
            dataList?.remove(at: position)
            
            reloadData()
        }
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
        
        return label
    }()
    
}
