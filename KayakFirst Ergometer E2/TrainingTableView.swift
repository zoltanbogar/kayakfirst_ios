//
//  TrainingTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

class TrainingTablewView: TableViewWithEmpty<SumTraining> {
    
    //MARK: properties
    var deleteCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    
    //MARK: init
    override init(view: UIView) {
        super.init(view: view)
        
        backgroundColor = Colors.colorTransparent
        separatorColor = Colors.colorDashBoardDivider
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: override abstract functions
    override func getEmptyView() -> UIView {
        return labelEmpty
    }
    
    override func getCellClass() -> AnyClass {
        return TrainingTablewViewCell.self
    }
    
    override func getHeaderView() -> AppTableViewHeader? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        (cell as! TrainingTablewViewCell).deleteCallback = deleteCallback
        
        return cell
    }
    
    private lazy var labelEmpty: UILabel! = {
        let label = AppUILabel()
        label.text = getString("calendar_empty_list")
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var headerView: AppTableViewHeader! = {
        let view = TrainingTableViewHeader()
        
        return view
    }()
}
