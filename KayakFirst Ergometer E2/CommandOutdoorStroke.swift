//
//  CommandOutdoorStroke.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CommandOutdoorStroke: MeasureCommand {
    
    override func getCommand() -> CommandEnum {
        return CommandEnum.stroke
    }
    
    //TODO
    override func getCycleIndex() -> Int64 {
        return 0
    }
    
}
