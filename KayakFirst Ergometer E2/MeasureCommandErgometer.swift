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
    
    //MARK: implement abstract methods
    override func getCycleIndex() -> Int64 {
        //TODO
        return 0
    }
    
    override func getValue() -> Double {
        //TODO
        return Double(0)
    }
    
    override func setValue(stringValue: String) {
        //TODO
    }
    
    //MARK: functions
    func initValue(stringValue: String) -> Int64 {
        //TODO
        return 0
    }
    
    func initCommandType(stringValue: String) -> Int {
        //TODO
        return 0
    }
    
    func initCycleIndex(stringValue: String) -> Int64 {
        //TODO
        return 0
    }
    
    func getStringByRowNumber(stringValue: String, rowNumber: Int) -> String {
        var foundRow = 0
        
        return ""
        //TODO
    }
    
}
