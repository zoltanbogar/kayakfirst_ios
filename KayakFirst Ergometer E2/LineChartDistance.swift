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
    private var distanceList: [[Training]]?
    
    //MARK: init
    override init(lineChart: LineChartView, position: Int, createTrainingList: CreateTrainingList) {
        super.init(lineChart: lineChart, position: position, createTrainingList: createTrainingList)
        
        distanceList = CalculateEnum.getTrainingListSumByLabel(label: CalculateEnum.S, createTrainingList: createTrainingList)
    }
    
    override func createEntries(trainingList: [[Training]], label: CalculateEnum) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        seqDistance = 0
        let trainings = trainingList[position]
        if trainings.count > 0 {
            entries = getDistanceEntryList(trainings: trainings)
        }
        return entries
    }
    
    private func getDistanceEntryList(trainings: [Training]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        
        var distance: Double = 0
        
        for i in 0..<trainings.count {
            if trainings[i].currentDistance == 0 {
                if i<distanceList![position].count {
                    distance = distanceList![position][i].dataValue
                    
                    entries.append(ChartDataEntry(x: seqDistance, y: trainings[i].dataValue))
                    
                    seqDistance = seqDistance + distance
                } else {
                    break
                }
            } else {
                distance = trainings[i].currentDistance
                
                entries.append(ChartDataEntry(x: distance, y: trainings[i].dataValue))
                
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
