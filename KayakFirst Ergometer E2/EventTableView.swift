//
//  PlanTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 05. 13..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class EventTableView: BaseCalendarTableView<PlanEvent> {
    
    //MARK: init
    override init(view: UIView) {
        super.init(view: view)
        
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
    
    //MARK: views
    private lazy var labelEmpty: UILabel! = {
        let label = AppUILabel()
        label.text = getString("calendar_empty_event")
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var headerView: EventTableViewHeader! = {
        let header = EventTableViewHeader()
        
        return header
    }()
}
