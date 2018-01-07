//
//  MeasureCommand.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 26..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class MeasureCommand {
    
    //MARK properties
    var stringValue: String?
    
    func setValue(stringValue: String) -> Bool {
        self.stringValue = stringValue
        
        return true
    }
    
    //MARK: abstract methods
    func getCommand() -> CommandEnum {
        fatalError("Must be implemented")
    }
    func getCycleIndex() -> Int64 {
        fatalError("Must be implemented")
    }
    func getValue() -> String? {
        fatalError("Must be implemented")
    }

}
