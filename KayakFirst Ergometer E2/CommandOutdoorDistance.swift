//
//  CommandOutdoorDistance.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 19..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CommandOutdoorDistance: MeasureCommand {
    
    override func getCommand() -> String {
        return CommandOutdoorEnum.distance.rawValue
    }
    
    override func getCycleIndex() -> Int64 {
        return 0
    }
    
}