//
//  LineChartTime.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Charts

class LineChartTime: AppLineChartData {
    
    //MARK: properties
    private var seqTimestamp: TimeInterval = 0
    fileprivate let dateFormatHelper = DateFormatHelper()
    
    override func createEntries(trainingList: [ChartTraining]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        seqTimestamp = 0
        if trainingList.count > 0 {
            entries = getTimeEntryList(trainings: trainingList)
        }
        
        return entries
    }
    
    private func getTimeEntryList(trainings: [ChartTraining]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        var timestamp = trainings[0].timestamp
        for training in trainings {
            let timestampDiff = training.timestamp - timestamp
            timestamp = training.timestamp
            
            entries.append(ChartDataEntry(x: seqTimestamp, y: training.value))
            
            seqTimestamp = seqTimestamp + timestampDiff
        }
        return entries
    }
    
    override func xAxisFormatter() -> IAxisValueFormatter {
        return XAxisFormatter(lineChartData: self)
    }
}

class XAxisFormatter: NSObject, IAxisValueFormatter {
    
    private var lineChartData: LineChartTime
    
    init(lineChartData: LineChartTime) {
        self.lineChartData = lineChartData
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value > 60 * 60 * 1000 {
            lineChartData.dateFormatHelper.format = TimeEnum.timeFormatThree
        } else {
            lineChartData.dateFormatHelper.format = TimeEnum.timeFormatTwo
        }
        
        
        return lineChartData.dateFormatHelper.getTime(millisec: value)!
    }
}
