//
//  EventManagerType.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum EventManagerType: Int, BaseManagerType {
    case upload = 0
    case download_event_days = 1
    case delete = 2
    case edit = 3
    case download_event = 4
    
    func isProgressShown() -> Bool {
        return self.rawValue > EventManagerType.download_event_days.rawValue
    }
}
