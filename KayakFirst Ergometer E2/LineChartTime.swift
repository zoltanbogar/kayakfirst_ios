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
    private var seqTimeStamp: TimeInterval = 0
    fileprivate let dateFormatHelper = DateFormatHelper()
    
    override func createEntries(trainingList: [[Training]], label: CalculateEnum) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        seqTimeStamp = 0
        let trainings = trainingList[position]
        if trainings.count > 0 {
            entries = getTimeEntryList(trainings: trainings)
        }
        
        return entries
    }
    
    private func getTimeEntryList(trainings: [Training]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        var timeStamp = trainings[0].timeStamp
        for training in trainings {
            let timeStampDiff = training.timeStamp - timeStamp
            timeStamp = training.timeStamp
            
            entries.append(ChartDataEntry(x: seqTimeStamp, y: training.dataValue))
            
            seqTimeStamp = seqTimeStamp + timeStampDiff
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
