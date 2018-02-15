//
//  BaseCalendarTableViewCell.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseCalendarTableViewCell<E>: AppUITableViewCell<E> {
    
    //MARK: properties
    var deleteCallback: ((_ data: Bool?, _ error: Responses?) -> ())?
    
}
