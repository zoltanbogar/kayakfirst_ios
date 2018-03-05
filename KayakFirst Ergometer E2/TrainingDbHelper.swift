//
//  TrainingDbHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 13..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class TrainingDbHelper: BaseDbHelper<SumChartTraining> {
    
    private let sessionId: Double
    
    init(sessionId: Double) {
        self.sessionId = sessionId
    }
    
    override func run() -> SumChartTraining? {
        var t200Charts = [ChartTraining]()
        var t500Charts = [ChartTraining]()
        var t1000Charts = [ChartTraining]()
        var speedCharts = [ChartTraining]()
        var forceCharts = [ChartTraining]()
        var strokesCharts = [ChartTraining]()
        
        let trainingList = TrainingDbLoader.sharedInstance.getTrainingsBySessionId(sessionId: sessionId)
        
        if let trainingList = trainingList {
            for training in trainingList {
                let timestamp = training.timestamp
                let distance = training.distance
                
                let t200 = ChartTraining(
                    value: UnitHelper.getPaceValue(pace: Pace.pace200, metricValue: training.t200),
                    timestamp: timestamp,
                    distance: distance)
                let t500 = ChartTraining(
                    value: UnitHelper.getPaceValue(pace: Pace.pace500, metricValue: training.t500),
                    timestamp: timestamp,
                    distance: distance)
                let t1000 = ChartTraining(
                    value: UnitHelper.getPaceValue(pace: Pace.pace1000, metricValue: training.t1000),
                    timestamp: timestamp,
                    distance: distance)
                let speed = ChartTraining(
                    value: UnitHelper.getSpeedValue(metricValue: training.speed),
                    timestamp: timestamp,
                    distance: distance)
                let force = ChartTraining(
                    value: UnitHelper.getForceValue(metricValue: training.force),
                    timestamp: timestamp,
                    distance: distance)
                let strokes = ChartTraining(
                    value: training.strokes,
                    timestamp: timestamp,
                    distance: distance)
                
                t200Charts.append(t200)
                t500Charts.append(t500)
                t1000Charts.append(t1000)
                speedCharts.append(speed)
                forceCharts.append(force)
                strokesCharts.append(strokes)
            }
        }
        
        return SumChartTraining(
            t200Charts: t200Charts,
            t500Charts: t500Charts,
            t1000Charts: t1000Charts,
            speedCharts: speedCharts,
            forceCharts: forceCharts,
            strokesCharts: strokesCharts)
    }
    
}
