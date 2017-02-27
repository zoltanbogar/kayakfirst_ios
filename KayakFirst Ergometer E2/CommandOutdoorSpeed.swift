//
//  CommandOutdoorSpeed.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CommandOutdoorSpeed: MeasureCommand {
    
    override func getCommand() -> String {
        return CommandOutdoorEnum.speed.rawValue
    }
    
    override func getCycleIndex() -> Int64 {
        return 0
    }
    
}
