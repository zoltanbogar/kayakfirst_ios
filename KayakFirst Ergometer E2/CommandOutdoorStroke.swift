//
//  CommandOutdoorStroke.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class CommandOutdoorStroke: MeasureCommandOutdoor {
    
    func setValue(value: Double) {
        let stringValue = CommandParser.getString(value: value)
        setValue(stringValue: stringValue)
    }
    
    override func getCommand() -> CommandEnum {
        return CommandEnum.stroke
    }
    
}
