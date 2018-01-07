//
//  MeausreCommandOutdoor.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 07..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class MeasureCommandOutdoor: MeasureCommand {
    
    override func getCycleIndex() -> Int64 {
        return 0
    }
    
    override func getValue() -> String? {
        return stringValue
    }
    
}
