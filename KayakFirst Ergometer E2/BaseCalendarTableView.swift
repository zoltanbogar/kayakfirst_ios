//
//  BaseCalendarTableView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseCalendarTableView<E>: TableViewWithEmpty<E> {
    
    //MARK: properties
    var deleteCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    var clickCallback: ((_ data: [E]?, _ position: Int) -> ())?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        (cell as! BaseCalendarTableViewCell<E>).deleteCallback = deleteCallback
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickCallback?(dataList, indexPath.row)
    }
    
}
