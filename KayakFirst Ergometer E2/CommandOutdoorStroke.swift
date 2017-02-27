//
//  CommandOutdoorStroke.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CommandOutdoorStroke: MeasureCommand {
    
    override func getCommand() -> String {
        return CommandOutdoorEnum.stroke.rawValue
    }
    
    override func getCycleIndex() -> Int64 {
        return Int64(value)
    }
    
}
