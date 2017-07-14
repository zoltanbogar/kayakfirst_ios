//
//  PlanTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class EventTableView: TableViewWithEmpty<PlanEvent> {
    
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
        return EventTabLeViewCell.self
    }
    
    override func getHeaderView() -> AppTableViewHeader? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        (cell as! EventTabLeViewCell).deleteCallback = deleteCallback
        
        return cell
    }
    
    //MARK: views
    private lazy var labelEmpty: UILabel! = {
        let label = AppUILabel()
        label.text = getString("calendar_empty_event")
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        
        return label
    }()
    
    private lazy var headerView: EventTableViewHeader! = {
        let header = EventTableViewHeader()
        
        return header
    }()
}
