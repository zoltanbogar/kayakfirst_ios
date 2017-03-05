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
        
        calStartTime()
        calDuration()
        calDistance()
        initTrainingEnvironmentType()
    }
    
    //MARK: calculation
    private func calStartTime() {
        if trainingList != nil && trainingList!.count > 0 {
            startTime = trainingList![0].timeStamp
        }
    }
    
    private func calDuration() {
        if trainingList != nil && trainingList!.count > 0 {
            var trainingsBySessionId = [[Training]]()
            var sessionId: TimeInterval = 0
            var trainingListEqualSessionId: [Training]? = nil
            for t in trainingList! {
                if sessionId != t.sessionId {
                    if trainingListEqualSessionId != nil {
                        trainingsBySessionId.append(trainingListEqualSessionId!)
                    }
                    trainingListEqualSessionId = [Training]()
                    sessionId = t.sessionId
                }
                if trainingListEqualSessionId != nil {
                    trainingListEqualSessionId?.append(t)
                }
            }
            trainingsBySessionId.append(trainingListEqualSessionId!)
            
            var duration: TimeInterval = 0
            for tL in trainingsBySessionId {
                let size = tL.count
                let startTime = tL[0].timeStamp
                let endTime = tL[size-1].timeStamp
                duration = duration + (endTime - startTime)
            }
            self.duration = duration
        }
    }
    
    private func calDistance() {
        if trainingList != nil && trainingList!.count > 0 {
            let currentDistance: Double = trainingList![(trainingList!.count - 1)].currentDistance
            
            if currentDistance != 0 {
                distance = currentDistance
            } else {
                var s: Double = 0
                for t in trainingList! {
                    if t.dataType == CalculateEnum.S.rawValue {
                        s = s + t.dataValue
                    }
                }
                distance = s
            }
            
        }
    }
    
    private func initTrainingEnvironmentType() {
        if trainingList != nil && trainingList!.count > 0 {
            trainingEnvironmentType = trainingList![0].trainingEnvironmentType
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
