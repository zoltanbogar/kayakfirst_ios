//
//  TrainingSumElementAvgTime.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 09..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class TrainingSumElementAvgTime: TrainingSumElementAverage {
    
    override func getFormatter() -> String {
        return ""
    }
    
    override func getFormattedValue(value: Double) -> String {
        let dateFormatHelper = DateFormatHelper()
        dateFormatHelper.format = TimeEnum.timeFormatTwo
        return dateFormatHelper.getTime(millisec: value)!
    }
    
}
