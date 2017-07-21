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
    var startTime: TimeInterval?
    private var duration: TimeInterval?
    private var distance: Double?
    var trainingList: [Training]?
    var trainingEnvironmentType: TrainingEnvironmentType?
    var sessionId: Double = 0
    
    var t200List = [Training]()
    var t500List = [Training]()
    var t1000List = [Training]()
    var strokesList = [Training]()
    var fList = [Training]()
    var vList = [Training]()
    var distanceList = [Training]()
    
    var avgT200: Double = 0
    var avgT500: Double = 0
    var avgT1000: Double = 0
    var avgStrokes: Double = 0
    var avgF: Double = 0
    var avgV: Double = 0
    
    var trainingAvgT200: TrainingAvg?
    var trainingAvgT500: TrainingAvg?
    var trainingAvgT1000: TrainingAvg?
    var trainingAvgStrokes: TrainingAvg?
    var trainingAvgF: TrainingAvg?
    var trainingAvgV: TrainingAvg?
    
    var maxT200: Double = 0
    var maxT500: Double = 0
    var maxT1000: Double = 0
    var maxStrokes: Double = 0
    var maxF: Double = 0
    var maxV: Double = 0
    
    var planTraining: PlanTraining?
    
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
    
    public class Builder {
        
        var trainings: [Training]?
        var avgTrainingHashMap: [String : TrainingAvg]?
        var planHashMap: [Double : PlanTraining]?
        
        init(trainings: [Training], avgTrainingHashMap: [String : TrainingAvg]?, planHashMap: [Double : PlanTraining]?) {
            self.trainings = trainings
            self.avgTrainingHashMap = avgTrainingHashMap
            self.planHashMap = planHashMap
        }
        
        private func getMax(training: Training, maxValue: Double) -> Double {
            if training.dataValue > maxValue {
                return training.dataValue
            }
            return maxValue
        }
        
        private func getMin(training: Training, minValue: Double) -> Double {
            if minValue == 0 || training.dataValue < minValue {
                return training.dataValue
            }
            return minValue
        }
        
        func getTrainingAvg(trainingType: String, sessionId: Double) -> TrainingAvg? {
            let hash = TrainingAvg.getAvgHash(userId: UserManager.sharedInstance.getUser()?.id, avgType: trainingType, sessionId: sessionId)
            if let map = avgTrainingHashMap {
                let trainingAvg = map[hash]
                
                return map[hash]
            }
            return nil
        }
        
        func getPlanTrainingBySessionId(sessionId: Double) -> PlanTraining? {
            if let map = planHashMap {
                return map[sessionId]
            }
            return nil
        }
        
        private func getSum(training: Training, sumValue: Double) -> Double {
            return sumValue + training.dataValue
        }
        
        func createSumTrainingList() -> [SumTraining]? {
            if trainings != nil && trainings!.count > 0 {
                var sumTrainingList = [SumTraining]()
                
                var uniqueTrainings = [Training]()
                var sessionIdTest: TimeInterval = trainings![0].sessionId
                
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
                
                var maxT200: Double = 0
                var maxT500: Double = 0
                var maxT1000: Double = 0
                var maxStrokes: Double = 0
                var maxF: Double = 0
                var maxV: Double = 0
                
                var sumT200: Double = 0
                var sumT500: Double = 0
                var sumT1000: Double = 0
                var sumStrokes: Double = 0
                var sumF: Double = 0
                var sumV: Double = 0
                
                var sumTraining: SumTraining = SumTraining()
                
                for t in trainings! {
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
                        
                        sumTraining.maxT200 = maxT200
                        sumTraining.maxT500 = maxT500
                        sumTraining.maxT1000 = maxT1000
                        sumTraining.maxF = maxF
                        sumTraining.maxV = maxV
                        sumTraining.maxStrokes = maxStrokes
                        
                        if avgTrainingHashMap == nil || avgTrainingHashMap!.count == 0 {
                            sumTraining.avgT200 = (sumT200 / Double(t200List.count))
                            sumTraining.avgT500 = (sumT500 / Double(t500List.count))
                            sumTraining.avgT1000 = (sumT1000 / Double(t1000List.count))
                            sumTraining.avgF = (sumF / Double(fList.count))
                            sumTraining.avgV = (sumV / Double(vList.count))
                            sumTraining.avgStrokes = (sumStrokes / Double(strokesList.count))
                        } else {
                            sumTraining.trainingAvgT200 = getTrainingAvg(trainingType: CalculateEnum.T_200_AV.rawValue, sessionId: sessionId)
                            sumTraining.trainingAvgT500 = getTrainingAvg(trainingType: CalculateEnum.T_500_AV.rawValue, sessionId: sessionId)
                            sumTraining.trainingAvgT1000 = getTrainingAvg(trainingType: CalculateEnum.T_1000_AV.rawValue, sessionId: sessionId)
                            sumTraining.trainingAvgF = getTrainingAvg(trainingType: CalculateEnum.F_AV.rawValue, sessionId: sessionId)
                            sumTraining.trainingAvgV = getTrainingAvg(trainingType: CalculateEnum.V_AV.rawValue, sessionId: sessionId)
                            sumTraining.trainingAvgStrokes = getTrainingAvg(trainingType: CalculateEnum.STROKES_AV.rawValue, sessionId: sessionId)
                            
                            sumTraining.avgT200 = sumTraining.trainingAvgT200?.avgValue ?? 0
                            sumTraining.avgT500 = sumTraining.trainingAvgT500?.avgValue ?? 0
                            sumTraining.avgT1000 = sumTraining.trainingAvgT1000?.avgValue ?? 0
                            sumTraining.avgF = sumTraining.trainingAvgF?.avgValue ?? 0
                            sumTraining.avgV = sumTraining.trainingAvgV?.avgValue ?? 0
                            sumTraining.avgStrokes = sumTraining.trainingAvgStrokes?.avgValue ?? 0
                        }
                        
                        sumTraining.planTraining = getPlanTrainingBySessionId(sessionId: sessionId)
                        
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
                        
                        maxT200 = 0
                        maxT500 = 0
                        maxT1000 = 0
                        maxStrokes = 0
                        maxF = 0
                        maxV = 0
                        
                        sumT200 = 0
                        sumT500 = 0
                        sumT1000 = 0
                        sumF = 0
                        sumV = 0
                        sumStrokes = 0
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
                        maxT200 = getMin(training: t, minValue: maxT200)
                        sumT200 = getSum(training: t, sumValue: sumT200)
                    } else if CalculateEnum.T_500.rawValue == t.dataType {
                        t500List.append(t)
                        maxT500 = getMin(training: t, minValue: maxT500)
                        sumT500 = getSum(training: t, sumValue: sumT500)
                    } else if CalculateEnum.T_1000.rawValue == t.dataType {
                        t1000List.append(t)
                        maxT1000 = getMin(training: t, minValue: maxT1000)
                        sumT1000 = getSum(training: t, sumValue: sumT1000)
                    } else if CalculateEnum.STROKES.rawValue == t.dataType {
                        strokesList.append(t)
                        maxStrokes = getMin(training: t, minValue: maxStrokes)
                        sumStrokes = getSum(training: t, sumValue: sumStrokes)
                    } else if CalculateEnum.F.rawValue == t.dataType {
                        fList.append(t)
                        maxF = getMin(training: t, minValue: maxF)
                        sumF = getSum(training: t, sumValue: sumF)
                    } else if CalculateEnum.V.rawValue == t.dataType {
                        vList.append(t)
                        maxV = getMin(training: t, minValue: maxV)
                        sumV = getSum(training: t, sumValue: sumV)
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
                
                sumTraining.maxT200 = maxT200
                sumTraining.maxT500 = maxT500
                sumTraining.maxT1000 = maxT1000
                sumTraining.maxF = maxF
                sumTraining.maxV = maxV
                sumTraining.maxStrokes = maxStrokes
                
                if avgTrainingHashMap == nil || avgTrainingHashMap!.count == 0 {
                    sumTraining.avgT200 = (sumT200 / Double(t200List.count))
                    sumTraining.avgT500 = (sumT500 / Double(t500List.count))
                    sumTraining.avgT1000 = (sumT1000 / Double(t1000List.count))
                    sumTraining.avgF = (sumF / Double(fList.count))
                    sumTraining.avgV = (sumV / Double(vList.count))
                    sumTraining.avgStrokes = (sumStrokes / Double(strokesList.count))
                } else {
                    sumTraining.trainingAvgT200 = getTrainingAvg(trainingType: CalculateEnum.T_200_AV.rawValue, sessionId: sessionId)
                    sumTraining.trainingAvgT500 = getTrainingAvg(trainingType: CalculateEnum.T_500_AV.rawValue, sessionId: sessionId)
                    sumTraining.trainingAvgT1000 = getTrainingAvg(trainingType: CalculateEnum.T_1000_AV.rawValue, sessionId: sessionId)
                    sumTraining.trainingAvgF = getTrainingAvg(trainingType: CalculateEnum.F_AV.rawValue, sessionId: sessionId)
                    sumTraining.trainingAvgV = getTrainingAvg(trainingType: CalculateEnum.V_AV.rawValue, sessionId: sessionId)
                    sumTraining.trainingAvgStrokes = getTrainingAvg(trainingType: CalculateEnum.STROKES_AV.rawValue, sessionId: sessionId)
                    
                    sumTraining.avgT200 = sumTraining.trainingAvgT200?.avgValue ?? 0
                    sumTraining.avgT500 = sumTraining.trainingAvgT500?.avgValue ?? 0
                    sumTraining.avgT1000 = sumTraining.trainingAvgT1000?.avgValue ?? 0
                    sumTraining.avgF = sumTraining.trainingAvgF?.avgValue ?? 0
                    sumTraining.avgV = sumTraining.trainingAvgV?.avgValue ?? 0
                    sumTraining.avgStrokes = sumTraining.trainingAvgStrokes?.avgValue ?? 0
                }
                
                sumTraining.planTraining = getPlanTrainingBySessionId(sessionId: sessionId)
                
                sumTrainingList.append(sumTraining)
                
                return sumTrainingList
            }
            return nil
        }
    }
}
