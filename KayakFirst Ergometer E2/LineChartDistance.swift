//
//  LineChartDistance.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 18..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import Charts

class LineChartDistance: AppLineChartData {
    
    override func createEntries(trainingList: [ChartTraining]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        if trainingList.count > 0 {
            entries = getDistanceEntryList(trainings: trainingList)
        }
        return entries
    }
    
    private func getDistanceEntryList(trainings: [ChartTraining]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        var distance: Double = 0
        
        for i in 0..<trainings.count {
            distance = UnitHelper.getDistanceValue(metricValue: trainings[i].distance)
            
            entries.append(ChartDataEntry(x: distance, y: trainings[i].value))
        }
        return entries
    }
    
    override func xAxisFormatter() -> IAxisValueFormatter {
        return XAxisFormatter()
    }
    
    class XAxisFormatter: NSObject, IAxisValueFormatter {
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return String(format: "%.0f", value)
        }
    }
}
