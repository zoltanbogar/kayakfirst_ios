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
    
    //MARK: properties
    private var seqDistance: Double = 0
    private let distanceList: [Training]
    
    //MARK: init
    init(lineChart: LineChartView, distanceList: [Training], position: Int) {
        self.distanceList = distanceList
        super.init(lineChart: lineChart, position: position)
    }
    
    override func createEntries(trainingList: [Training], label: CalculateEnum) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        seqDistance = 0
        if trainingList.count > 0 {
            entries = getDistanceEntryList(trainings: trainingList)
        }
        return entries
    }
    
    private func getDistanceEntryList(trainings: [Training]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        var distance: Double = 0
        
        for i in 0..<trainings.count {
            if trainings[i].currentDistance == 0 {
                if i<distanceList.count {
                    distance = UnitHelper.getTrainingValue(training: distanceList[i])
                    
                    entries.append(ChartDataEntry(x: seqDistance, y: UnitHelper.getTrainingValue(training: trainings[i])))
                    
                    seqDistance = seqDistance + distance
                } else {
                    break
                }
            } else {
                distance = UnitHelper.getDistanceValue(metricValue: trainings[i].currentDistance)
                
                entries.append(ChartDataEntry(x: distance, y: UnitHelper.getTrainingValue(training: trainings[i])))
                
                seqDistance = distance
            }
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
