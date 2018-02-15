//
//  ViewEventCalendarList.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewEventCalendarListLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        tableView.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.center.equalTo(tableView)
        }
    }
    
    lazy var tableView: EventTableView! = {
        let tableViewEvent = EventTableView(view: self.contentView)
        
        return tableViewEvent
    }()
    
    lazy var progressBar: AppProgressBar! = {
        let spinner = AppProgressBar()
        
        return spinner
    }()
    
}
