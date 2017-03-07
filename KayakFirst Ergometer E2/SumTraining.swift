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
            return String(format: "%.0f", distance!) + " m"
        }
    }
    
    //MARK: init
    init(trainingList: [Training]) {
        self.trainingList = trainingList
        
        initTrainingDetails()
    }
    
    //MARK: calculation
    private func initTrainingDetails() {
        if trainingList != nil && trainingList!.count > 0 {
            self.startTime = trainingList![0].timeStamp
            trainingEnvironmentType = trainingList![0].trainingEnvironmentType
            sessionId = trainingList![0].sessionId
            
            var s: Double = 0
            
            let startTime = trainingList![0].timeStamp
            var endTime = trainingList![0].timeStamp
            
            for training in trainingList! {
                if CalculateEnum.T_200.rawValue == training.dataType {
                    t200List.append(training)
                } else if CalculateEnum.T_500.rawValue == training.dataType {
                    t500List.append(training)
                } else if CalculateEnum.T_1000.rawValue == training.dataType {
                    t1000List.append(training)
                } else if CalculateEnum.STROKES.rawValue == training.dataType {
                    strokesList.append(training)
                } else if CalculateEnum.F.rawValue == training.dataType {
                    fList.append(training)
                } else if CalculateEnum.V.rawValue == training.dataType {
                    vList.append(training)
                } else if CalculateEnum.S.rawValue == training.dataType {
                    distanceList.append(training)
                    s += training.dataValue
                }
                endTime = training.timeStamp
            }
            
            duration = endTime - startTime
            
            let currentDistance: Double = trainingList![(trainingList!.count - 1)].currentDistance
            
            if currentDistance != 0 {
                distance = currentDistance
            } else {
                distance = s
            }
        }
    }
    
    public class func createSumTrainingList(trainings: [Training]) -> [SumTraining]? {
        if trainings.count > 0 {
            var sumTrainingList = [SumTraining]()
            
            var uniqueTrainings = [Training]()
            var sessionId: TimeInterval = trainings[0].sessionId
            
            for t in trainings {
                if t.sessionId != sessionId {
                    sumTrainingList.append(SumTraining(trainingList: uniqueTrainings))
                    uniqueTrainings = [Training]()
                    sessionId = t.sessionId
                }
                uniqueTrainings.append(t)
            }
            sumTrainingList.append(SumTraining(trainingList: uniqueTrainings))
            return sumTrainingList
        }
        return nil
    }
    
    static func == (lhs: SumTraining, rhs: SumTraining) -> Bool {
        return lhs.duration == rhs.duration && lhs.startTime == rhs.startTime
    }
    
}
