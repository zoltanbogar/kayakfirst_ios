//
//  SumTraining.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 02. 07..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
class SumTraining: Equatable {
    
    //MARK: constants
    private let oneHourMilliseconds: TimeInterval = 60 * 60 * 1000
    
    //MARK: properties
    var startTime: TimeInterval?
    private var duration: TimeInterval?
    private var distance: Double?
    var trainingList: [Training]?
    var trainingEnvironmentType: TrainingEnvironmentType?
    var sessionId: Double?
    
    var t200List = [Training]()
    var t500List = [Training]()
    var t1000List = [Training]()
    var strokesList = [Training]()
    var fList = [Training]()
    var vList = [Training]()
    var distanceList = [Training]()
    
    private let dateFormatHelper = DateFormatHelper()
    
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
            return String(format: "%.0f", UnitHelper.getDistanceValue(metricValue: distance!)) + UnitHelper.getDistanceUnit()
        }
    }
    
    //MARK: init
    public class func createSumTrainingList(trainings: [Training]) -> [SumTraining]? {
        if trainings.count > 0 {
            var sumTrainingList = [SumTraining]()
            
            var uniqueTrainings = [Training]()
            var sessionIdTest: TimeInterval = trainings[0].sessionId
            
            var sessionId: TimeInterval = 0
            var trainingEnvironmentType: TrainingEnvironmentType?
            var startTime: Double = 0
            var endTime: Double = 0
            var distance: Double = 0
            var t200List = [Training]()
            var t500List = [Training]()
            var t1000List = [Training]()
            var strokesList = [Training]()
            var fList = [Training]()
            var vList = [Training]()
            var distanceList = [Training]()
            
            var sumTraining: SumTraining = SumTraining()
            
            for t in trainings {
                if t.sessionId != sessionIdTest {
                    sumTraining = SumTraining()
                    sumTraining.sessionId = sessionId
                    sumTraining.trainingList = uniqueTrainings
                    sumTraining.trainingEnvironmentType = trainingEnvironmentType
                    sumTraining.startTime = startTime
                    sumTraining.duration = (endTime - startTime)
                    let currentDistance = uniqueTrainings[(uniqueTrainings.count - 1)].currentDistance
                    if currentDistance != 0 {
                        sumTraining.distance = currentDistance
                    } else {
                        sumTraining.distance = distance
                    }
                    sumTraining.t200List = t200List
                    sumTraining.t500List = t500List
                    sumTraining.t1000List = t1000List
                    sumTraining.strokesList = strokesList
                    sumTraining.fList = fList
                    sumTraining.vList = vList
                    sumTraining.distanceList = distanceList
                    
                    sumTrainingList.append(sumTraining)
                    uniqueTrainings = [Training]()
                    sessionIdTest = t.sessionId
                    
                    sessionId = 0
                    trainingEnvironmentType = nil
                    startTime = 0
                    distance = 0
                    t200List = [Training]()
                    t500List = [Training]()
                    t1000List = [Training]()
                    strokesList = [Training]()
                    fList = [Training]()
                    vList = [Training]()
                    distanceList = [Training]()
                }
                
                if sessionId == 0 {
                    sessionId = t.sessionId
                }
                if trainingEnvironmentType == nil {
                    trainingEnvironmentType = t.trainingEnvironmentType
                }
                if startTime == 0 {
                    startTime = t.timeStamp
                }
                endTime = t.timeStamp
                
                if CalculateEnum.T_200.rawValue == t.dataType {
                    t200List.append(t)
                } else if CalculateEnum.T_500.rawValue == t.dataType {
                    t500List.append(t)
                } else if CalculateEnum.T_1000.rawValue == t.dataType {
                    t1000List.append(t)
                } else if CalculateEnum.STROKES.rawValue == t.dataType {
                    strokesList.append(t)
                } else if CalculateEnum.F.rawValue == t.dataType {
                    fList.append(t)
                } else if CalculateEnum.V.rawValue == t.dataType {
                    vList.append(t)
                } else if CalculateEnum.S.rawValue == t.dataType {
                    distanceList.append(t)
                    distance += t.dataValue
                }
                
                uniqueTrainings.append(t)
            }
            sumTraining = SumTraining()
            sumTraining.sessionId = sessionId
            sumTraining.trainingList = uniqueTrainings
            sumTraining.trainingEnvironmentType = trainingEnvironmentType
            sumTraining.startTime = startTime
            sumTraining.duration = (endTime - startTime)
            let currentDistance = uniqueTrainings[(uniqueTrainings.count - 1)].currentDistance
            if currentDistance != 0 {
                sumTraining.distance = currentDistance
            } else {
                sumTraining.distance = distance
            }
            sumTraining.t200List = t200List
            sumTraining.t500List = t500List
            sumTraining.t1000List = t1000List
            sumTraining.strokesList = strokesList
            sumTraining.fList = fList
            sumTraining.vList = vList
            sumTraining.distanceList = distanceList
            
            sumTrainingList.append(sumTraining)
            
            return sumTrainingList
        }
        return nil
    }
    
    static func == (lhs: SumTraining, rhs: SumTraining) -> Bool {
        return Int64(lhs.sessionId!) == Int64(rhs.sessionId!)
    }
    
}
