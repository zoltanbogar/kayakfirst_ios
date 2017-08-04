//
//  PlanTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 06..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class PlanTableView: TableViewWithEmpty<Plan> {
    
    //MARK: properties
    private var deleteCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    
    //MARK: init
    init(view: UIView, deleteCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        super.init(view: view)
        self.deleteCallback = deleteCallback
        
        backgroundColor = Colors.colorTransparent
        separatorColor = Colors.colorDashBoardDivider
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: functions
    override func getEmptyView() -> UIView {
        return labelEmpty
    }
    
    override func getCellClass() -> AnyClass {
        return PlanTableViewCell.self
    }
    
    override func getHeaderView() -> AppTableViewHeader? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        (cell as! PlanTableViewCell).deleteCallback = deleteCallback
        
        return cell
    }
    
    //MARK: views
    private lazy var labelEmpty: UILabel! = {
        let label = AppUILabel()
        label.text = getString("plan_empty")
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        
        return label
    }()
    
    private lazy var headerView: PlanTableViewHeader! = {
        let header = PlanTableViewHeader()
        
        return header
    }()
}
