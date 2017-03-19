//
//  MeasureCommand.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum CommandOutdoorEnum: String {
    case distance = "distance"
    case speed = "speed"
    case stroke = "stroke"
}

class MeasureCommand {
    
    //MARK properties
    var value: Double = 0
    
    //MARK: abstract methods
    func getCommand() -> String {
        fatalError("Must be implemented")
    }
    func getCycleIndex() -> Int64 {
        fatalError("Must be implemented")
    }
    func getValue() -> Double {
        fatalError("Must be implemented")
    }
    func setValue(value: AnyObject) {
        fatalError("Must be implemented")
    }
    
}
