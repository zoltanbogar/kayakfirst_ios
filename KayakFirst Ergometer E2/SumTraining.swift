//
//  SumTraining.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class SumTraining: Equatable, ModifyAble {
    
    //MARK: constants
    private let oneHourMilliseconds: TimeInterval = 60 * 60 * 1000
    
    //MARK: properties
    var startTime: TimeInterval = 0
    private var duration: TimeInterval?
    private var distance: Double?
    var trainingList: [Training]?
    var trainingEnvironmentType: TrainingEnvironmentType?
    var sessionId: Double = 0
    
    var t200List: [Training]
    var t500List: [Training]
    var t1000List: [Training]
    var strokesList: [Training]
    var fList: [Training]
    var vList: [Training]
    var distanceList: [Training]
    
    var avgT200: Double = 0
    var avgT500: Double = 0
    var avgT1000: Double = 0
    var avgStrokes: Double = 0
    var avgF: Double = 0
    var avgV: Double = 0
    
    var planTraining: PlanTraining?
    
    private let dateFormatHelper = DateFormatHelper()
    
    //MARK: init
    init(
        t200List: [Training],
        t500List: [Training],
        t1000List: [Training],
        strokesList: [Training],
        fList: [Training],
        vList: [Training],
        distanceList: [Training],
        trainingAvgT200: TrainingAvg?,
        trainingAvgT500: TrainingAvg?,
        trainingAvgT1000: TrainingAvg?,
        trainingAvgStrokes: TrainingAvg?,
        trainingAvgF: TrainingAvg?,
        trainingAvgV: TrainingAvg?,
        planTraining: PlanTraining?
        ) {
        self.t200List = t200List
        self.t500List = t500List
        self.t1000List = t1000List
        self.strokesList = strokesList
        self.fList = fList
        self.vList = vList
        self.distanceList = distanceList
        self.planTraining = planTraining
        
        if distanceList.count > 0 {
            startTime = distanceList[0].timeStamp
            duration = distanceList[distanceList.count - 1].timeStamp - startTime
            sessionId = distanceList[0].sessionId
            trainingEnvironmentType = distanceList[0].trainingEnvironmentType
            
            let currentDistance = distanceList[distanceList.count - 1].currentDistance
            if currentDistance != Training.defaultDistance {
                distance = currentDistance
            } else {
                var localeDistance: Double = 0
                for t in distanceList {
                    localeDistance += t.dataValue
                }
                distance = localeDistance
            }
        }
        
        avgT200 = initAvg(trainingAvg: trainingAvgT200, trainings: t200List)
        avgT500 = initAvg(trainingAvg: trainingAvgT500, trainings: t500List)
        avgT1000 = initAvg(trainingAvg: trainingAvgT1000, trainings: t1000List)
        avgStrokes = initAvg(trainingAvg: trainingAvgStrokes, trainings: strokesList)
        avgF = initAvg(trainingAvg: trainingAvgF, trainings: fList)
        avgV = initAvg(trainingAvg: trainingAvgV, trainings: vList)
    }
    
    private func initAvg(trainingAvg: TrainingAvg?, trainings: [Training]) -> Double {
        if let trainingAvgValue = trainingAvg {
            return trainingAvgValue.avgValue
        } else {
            var sum: Double = 0
            for t in trainings {
                sum += t.dataValue
            }
            return sum / Double(trainings.count)
        }
        return 0
    }
    
    var formattedStartTime: String {
        get {
            return DateFormatHelper.getDate(dateFormat: DateFormatHelper.timeFormat, timeIntervallSince1970: startTime)
        }
    }
    
    var formattedDuration: String {
        get {
            var format = TimeEnum.timeFormatTwo
            
            if duration! > oneHourMilliseconds {
                format = TimeEnum.timeFormatThree
            }
            
            dateFormatHelper.format = format
            return dateFormatHelper.getTime(millisec: duration!)!
        }
    }
    
    var formattedDistance: String {
        get {
            return String(format: "%.0f", UnitHelper.getDistanceValue(metricValue: distance!)) + " " + UnitHelper.getDistanceUnit()
        }
    }
    
    //MARK: protocol
    static func == (lhs: SumTraining, rhs: SumTraining) -> Bool {
        return Int64(lhs.sessionId) == Int64(rhs.sessionId)
    }
    
    func getUploadPointer() -> String {
        return "\(sessionId ?? 0)"
    }
    
    func getParameters() -> [String : Any] {
        //nothing here
        return ["":""]
    }
}
