//
//  MeasureCommandErgometer.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 08. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class MeasureCommandErgometer: MeasureCommand {
    
    //MARK: constants
    private let numCommandType = 1
    private let numCycleIndex = 2
    private let numValue = 3
    private let unitConversion: Double = 1000 * 1000
    
    //MARK: properties
    private var stringValue: String?
    
    //MARK: implement abstract methods
    override func getCycleIndex() -> Int64 {
        if let value = stringValue {
            return initCycleIndex(stringValue: value)
        }
        return 0
    }
    
    override func getValue() -> Double {
        //UNIT: [sec]
        return value / unitConversion
    }
    
    override func setValue(stringValue: String) {
        self.stringValue = stringValue
        if Int(getCommand()) == initCommandType(stringValue: stringValue) {
            value = Double(initValue(stringValue: stringValue))
        }
    }
    
    //MARK: functions
    func initValue(stringValue: String) -> Int64 {
        let valueSub = getStringByRowNumber(stringValue: stringValue, rowNumber: numValue)
        return Int64(valueSub)!
    }
    
    func initCommandType(stringValue: String) -> Int {
        let commandType = getStringByRowNumber(stringValue: stringValue, rowNumber: numCommandType)
        return Int(commandType)!
    }
    
    func initCycleIndex(stringValue: String) -> Int64 {
        let cycleIndexString = getStringByRowNumber(stringValue: stringValue, rowNumber: numCycleIndex)
        return Int64(cycleIndexString)!
    }
    
    func getStringByRowNumber(stringValue: String, rowNumber: Int) -> String {
        var foundRow = 0
        
        var stringBuilder: String = ""
        
        for i in 0..<stringValue.characters.count {
            let character = stringValue[i]
            
            if character == "\n" {
                foundRow += 1
                
                if foundRow == rowNumber {
                    break
                } else {
                    stringBuilder = ""
                }
            } else {
               stringBuilder += character
            }
        }
        
        return stringBuilder
    }
    
}
