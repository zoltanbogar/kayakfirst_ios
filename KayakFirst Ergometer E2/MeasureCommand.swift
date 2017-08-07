//
//  MeasureCommand.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

enum CommandErgometerEnum: String {
    case tMin = "1"
    case tH = "2"
    case tMax = "3"
    case tV = "4"
    case rpm = "5"
    case reset = "9"
}

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
    func setValue(stringValue: String) {
        fatalError("Must be implemented")
    }
}
