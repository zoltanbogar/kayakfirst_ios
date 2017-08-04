//
//  TableView+.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

extension UITableView {
    
    func scrollToPosition(position: Int) {
        let indexPath = IndexPath(row: position, section: 0)
        
        scrollToRow(at: indexPath, at: UITableViewScrollPosition.none, animated: true)
    }
}
