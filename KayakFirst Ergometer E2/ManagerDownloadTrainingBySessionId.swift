//
//  ManagerDownloadTrainingBySessionId.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class ManagerDownloadTrainingBySessionId: ManagerDownload<[SumTraining]>, ManagerDownloadProtocol {
    
    //MARK: constants
    private let trainingDbLoader = TrainingDbLoader.sharedInstance
    private let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
    private let planTrainingDbLoader = PlanTrainingDbLoader.sharedInstance
    
    //MARK: properties
    private let sessionIds: [Double]
    
    private var trainings: [Training]?
    private var trainingAvgs: [TrainingAvg]?
    private var planTrainings: [PlanTraining]?
    
    private var localeSumTrainings: [SumTraining]?
    
    //MARK: init
    init(sessionIds: [Double]) {
        self.sessionIds = sessionIds
    }
    
    //MARK: functions
    override func shouldWaitForStack() -> Bool {
        return localeSumTrainings != nil && localeSumTrainings!.count > 0
    }
    
    override func getDataFromLocale() -> [SumTraining]? {
        localeSumTrainings = [SumTraining]()
        
        for sessionId in sessionIds {
            let t200List = trainingDbLoader.loadData(predicate: getQueryTrainingByType(sessionId: sessionId, type: CalculateEnum.T_200))
            let t500List = trainingDbLoader.loadData(predicate: getQueryTrainingByType(sessionId: sessionId, type: CalculateEnum.T_500))
            let t1000List = trainingDbLoader.loadData(predicate: getQueryTrainingByType(sessionId: sessionId, type: CalculateEnum.T_1000))
            let strokesList = trainingDbLoader.loadData(predicate: getQueryTrainingByType(sessionId: sessionId, type: CalculateEnum.STROKES))
            let fList = trainingDbLoader.loadData(predicate: getQueryTrainingByType(sessionId: sessionId, type: CalculateEnum.F))
            let vList = trainingDbLoader.loadData(predicate: getQueryTrainingByType(sessionId: sessionId, type: CalculateEnum.V))
            let sList = trainingDbLoader.loadData(predicate: getQueryTrainingByType(sessionId: sessionId, type: CalculateEnum.S))
            
            var t200Avg: TrainingAvg? = nil
            var t200AvgList = trainingAvgDbLoader.loadData(predicate: getQueryTrainingAvgByType(sessionId: sessionId, type: CalculateEnum.T_200_AV))
            if t200AvgList != nil && t200AvgList!.count > 0 {
                t200Avg = t200AvgList![0]
            }
            var t500Avg: TrainingAvg? = nil
            var t500AvgList = trainingAvgDbLoader.loadData(predicate: getQueryTrainingAvgByType(sessionId: sessionId, type: CalculateEnum.T_500_AV))
            if t500AvgList != nil && t500AvgList!.count > 0 {
                t500Avg = t500AvgList![0]
            }
            var t1000Avg: TrainingAvg? = nil
            var t1000AvgList = trainingAvgDbLoader.loadData(predicate: getQueryTrainingAvgByType(sessionId: sessionId, type: CalculateEnum.T_1000_AV))
            if t1000AvgList != nil && t1000AvgList!.count > 0 {
                t1000Avg = t1000AvgList![0]
            }
            var strokesAvg: TrainingAvg? = nil
            var strokesAvgList = trainingAvgDbLoader.loadData(predicate: getQueryTrainingAvgByType(sessionId: sessionId, type: CalculateEnum.STROKES_AV))
            if strokesAvgList != nil && strokesAvgList!.count > 0 {
                strokesAvg = strokesAvgList![0]
            }
            var fAvg: TrainingAvg? = nil
            var fAvgList = trainingAvgDbLoader.loadData(predicate: getQueryTrainingAvgByType(sessionId: sessionId, type: CalculateEnum.F_AV))
            if fAvgList != nil && fAvgList!.count > 0 {
                fAvg = fAvgList![0]
            }
            var vAvg: TrainingAvg? = nil
            var vAvgList = trainingAvgDbLoader.loadData(predicate: getQueryTrainingAvgByType(sessionId: sessionId, type: CalculateEnum.V_AV))
            if vAvgList != nil && vAvgList!.count > 0 {
                vAvg = vAvgList![0]
            }
            
            var planTraining: PlanTraining? = nil
            var planTrainingList = planTrainingDbLoader.loadData(predicate: getQueryPlanBySessionId(sessionId: sessionId))
            if planTrainingList != nil && planTrainingList!.count > 0 {
                planTraining = planTrainingList![0]
            }
            
            if t200List != nil && t500List != nil && t1000List != nil && strokesList != nil && fList != nil && vList != nil && sList != nil {
                let sumTraining = SumTraining(
                    t200List: t200List!,
                    t500List: t500List!,
                    t1000List: t1000List!,
                    strokesList: strokesList!,
                    fList: fList!,
                    vList: vList!,
                    distanceList: sList!,
                    trainingAvgT200: t200Avg,
                    trainingAvgT500: t500Avg,
                    trainingAvgT1000: t1000Avg,
                    trainingAvgStrokes: strokesAvg,
                    trainingAvgF: fAvg,
                    trainingAvgV: vAvg,
                    planTraining: planTraining)
                
                if sumTraining.sessionId != 0 {
                    localeSumTrainings!.append(sumTraining)
                }
            }
        }
        
        if let sumTrainings = localeSumTrainings {
            localeSumTrainings = sumTrainings.sorted(by: { $0.startTime < $1.startTime })
        }
        
        return localeSumTrainings
    }
    
    override func runServer() -> [SumTraining]? {
        let downloadTrainings = DownloadTrainings(sessionIdFrom: getSessionIdFrom(sessionIds: sessionIds), sessionIdTo: getSessionIdTo(sessionIds: sessionIds))
        trainings = downloadTrainings.run()
        serverError = downloadTrainings.error
        
        let downloadTrainingAvgs = DownloadTrainingAvgs(sessionIdFrom: getSessionIdFrom(sessionIds: sessionIds), sessionIdTo: getSessionIdTo(sessionIds: sessionIds))
        trainingAvgs = downloadTrainingAvgs.run()
        serverError = downloadTrainingAvgs.error
        
        let downloadPlanBySessionId = DownloadPlanTrainingBySessionId(sessionIdFrom: getSessionIdFrom(sessionIds: sessionIds), sessionIdTo: getSessionIdTo(sessionIds: sessionIds))
        planTrainings = downloadPlanBySessionId.run()
        serverError = downloadPlanBySessionId.error
        
        return nil
    }
    
    override func deleteDataFromLocale() {
        trainingDbLoader.deleteData(predicate: getQueryTraining())
        trainingAvgDbLoader.deleteData(predicate: getQueryTrainingAvg())
        planTrainingDbLoader.deleteData(predicate: getQueryPlan())
    }
    
    override func addDataToLocale(data: [SumTraining]?) {
        if let trainingsValue = trainings {
            trainingDbLoader.addTrainings(trainings: trainingsValue)
        }
        if let trainingAvgsValue = trainingAvgs {
            trainingAvgDbLoader.addTrainingAvgs(trainingAvgs: trainingAvgsValue)
        }
        if let planTrainingsValue = planTrainings {
            planTrainingDbLoader.addPlanTrainings(planTrainings: planTrainingsValue)
        }
    }
    
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadTrainingBySessionId &&
        (anotherManagerDownload as! ManagerDownloadTrainingBySessionId).getKeyCache() == self.getKeyCache()
    }
    
    override func getKeyCache() -> String {
        var stringBuilder: String = ""
        
        for sessionId in sessionIds {
            stringBuilder = stringBuilder + String(sessionId)
        }
        
        let sessionIdFrom = DateFormatHelper.getZeroHour(timeStamp: getSessionIdFrom(sessionIds: sessionIds))
        let sessionIdTo = DateFormatHelper.get23Hour(timeStamp: getSessionIdTo(sessionIds: sessionIds))
        
        return "manager_download_training_sessionid_\(sessionIdFrom)_\(sessionIdTo)"
    }
    
    private func getQueryTrainingByType(sessionId: Double, type: CalculateEnum) -> Expression<Bool> {
        return trainingDbLoader.getTrainingsByTypePredicate(sessionId: sessionId, type: type)
    }
    
    private func getQueryTrainingAvgByType(sessionId: Double, type: CalculateEnum) -> Expression<Bool> {
        return trainingAvgDbLoader.getTrainingAvgsByTypePredicate(sessionId: sessionId, type: type)
    }
    
    private func getQueryPlanBySessionId(sessionId: Double) -> Expression<Bool> {
        return planTrainingDbLoader.getExpressionBySessionId(sessionId: sessionId)
    }
    
    private func getQueryTraining() -> Expression<Bool> {
        return trainingDbLoader.getTrainingsBetweenSessionIdPredicate(sessionIdFrom: getSessionIdFrom(sessionIds: sessionIds), sessionIdTo: getSessionIdTo(sessionIds: sessionIds))
    }
    
    private func getQueryTrainingAvg() -> Expression<Bool> {
        return trainingAvgDbLoader.getTrainingAvgsBetweenSessionIdPredicate(sessionIdFrom: getSessionIdFrom(sessionIds: sessionIds), sessionIdTo: getSessionIdTo(sessionIds: sessionIds))
    }
    
    private func getQueryPlan() -> Expression<Bool>? {
        return planTrainingDbLoader.getExpressionSessionId(sessionIdFrom: getSessionIdFrom(sessionIds: sessionIds), sessionIdTo: getSessionIdTo(sessionIds: sessionIds))
    }
    
}
