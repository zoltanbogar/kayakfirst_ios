//
//  CommandErgometerReset.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CommandErgometerReset: MeasureCommandErgometer {
    
    //MARK: constants
    private let numValue = 1
    
    private let resetOk = "OK"
    let resetSuccess: Int64 = 1
    private let resetNotSuccess: Int64 = -1
    let tryResetNumber = 8
    
    override func getCommand() -> String {
        return CommandErgometerEnum.reset.rawValue
    }
    
    override func setValue(stringValue: String) -> Bool {
        initValue(stringValue: stringValue)
        
        value = Double(initValue(stringValue: stringValue))
        
        return true
    }
    
    override func isValidCommand(stringValue: String) -> Bool {
        return initValue(stringValue: stringValue) == resetSuccess || initValue(stringValue: stringValue) == resetNotSuccess
    }
    
    override func getValue() -> Double {
        return value
    }
    
    override func initValue(stringValue: String) -> Int64 {
        let subValue = getStringByRowNumber(stringValue: stringValue, rowNumber: numValue)
        
        if resetOk == subValue {
            return resetSuccess
        } else {
            return resetNotSuccess
        }
    }
    
    override func initCommandType(stringValue: String) -> Int {
        return 0
    }
    
    override func initCycleIndex(stringValue: String) -> Int64 {
        return 0
    }
}
