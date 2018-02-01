//
//  LogManagerType.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 01..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum LogManagerType: Int, BaseManagerType {
    
    case downloadMessage = 0
    case downloadVersion = 1
    case send_feedback = 2
    
    func isProgressShown() -> Bool {
        return self.rawValue > LogManagerType.downloadVersion.rawValue
    }
}
