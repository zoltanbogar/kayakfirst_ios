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
    
    static let resetSuccess: String = "reset_success"
    static let tryResetNumber = 8
    
    private let resetFailed: String = "reset_failed"
    
    override func getCommand() -> CommandEnum {
        return CommandEnum.reset
    }
    
    override func setValue(stringValue: String) -> Bool {
        super.setValue(stringValue: checkValue(stringValue: stringValue))
        
        return true
    }
    
    override func getValue() -> String {
        return stringValue!
    }
    
    func checkValue(stringValue: String) -> String {
        let subValue = getStringByRowNumber(stringValue: stringValue, rowNumber: numValue)
        
        if resetOk == subValue {
            return CommandErgometerReset.resetSuccess
        } else {
            return resetFailed
        }
    }
    
    override func initCommandType(stringValue: String) -> Int {
        return 0
    }
    
    override func initCycleIndex(stringValue: String) -> Int64 {
        return 0
    }
}
