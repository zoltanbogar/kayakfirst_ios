//
//  CommandOutdoorLongitude.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CommandOutdoorLongitude: MeasureCommand {
    
    override func getCommand() -> String {
        return CommandOutdoorEnum.longitude.rawValue
    }
    
    override func getCycleIndex() -> Int64 {
        return 0
    }
    
}
