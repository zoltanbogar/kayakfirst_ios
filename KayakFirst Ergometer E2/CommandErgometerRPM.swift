//
//  CommandErgometerRPM.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CommandErgometerRPM: MeasureCommandErgometer {
    
    //MARK: constants
    private let numValue = 2
    
    override func getCommand() -> CommandEnum {
        return CommandEnum.rpm
    }
    
    override func initValue(stringValue: String) -> Int64 {
        let valueSub = getStringByRowNumber(stringValue: stringValue, rowNumber: numValue)
        
        return Int64(valueSub)!
    }
    
    override func initCycleIndex(stringValue: String) -> Int64 {
        return 0
    }
    
}
