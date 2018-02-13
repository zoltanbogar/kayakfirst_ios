//
//  ManagerDownloadTrainingBySessionId.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class ManagerDownloadTrainingBySessionId: ManagerDownload<[SumTrainingNew]>, ManagerDownloadProtocol {
    
    //MARK: constants
    private let trainingDbLoader = TrainingDbLoader.sharedInstance
    private let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
    private let sumTrainingDbLoader = SumTrainingDbLoader.sharedInstance
    private let planTrainingDbLoader = PlanTrainingDbLoader.sharedInstance
    
    //MARK: properties
    private var sessionIds: [Double]
    
    private var trainings: [Training]?
    private var trainingAvgs: [TrainingAvg]?
    private var planTrainings: [PlanTraining]?
    
    private var localeSumTrainings: [SumTrainingNew]?
    
    //MARK: init
    init(sessionIds: [Double]) {
        self.sessionIds = sessionIds
    }
    
    //MARK: functions
    override func shouldWaitForStack() -> Bool {
        return true
    }
    
    override func callServer() -> String? {
        return serverError?.rawValue
    }
    
    override func getDataFromServer() -> [SumTrainingNew]? {
        return localeSumTrainings
    }
    
    override func getDataFromLocale() -> [SumTrainingNew]? {
        var localeSessionIds: [Double]? = nil
        
        localeSumTrainings = [SumTrainingNew]()
        
        for sessionId in sessionIds {
            if localeSessionIds == nil {
                localeSessionIds = [Double]()
            }
            let sumTraining = getSumTrainingBySessionId(sessionId: sessionId)
            if sumTraining != nil && sumTraining!.sessionId != 0 {
                localeSessionIds!.append(sumTraining!.sessionId)
                localeSumTrainings!.append(sumTraining!)
            }
        }
        
        if localeSessionIds != nil {
            sessionIds = Array(Set(sessionIds).subtracting(localeSessionIds!))
        }
        
        runServer()
        
        addDataToLocale(data: nil)
        
        for sessionId in sessionIds {
            let sumTraining = getSumTrainingBySessionId(sessionId: sessionId)
            if sumTraining?.sessionId != 0 {
                if sumTraining != nil {
                    localeSumTrainings?.append(sumTraining!)
                }
            }
        }
        
        if let sumTrainings = localeSumTrainings {
            localeSumTrainings = sumTrainings.sorted(by: { $0.startTime < $1.startTime })
        }
        
        return localeSumTrainings
    }
    
    override func runServer() -> [SumTrainingNew]? {
        //TODO
        /*for sessionId in sessionIds {
            if trainings == nil {
                trainings = [Training]()
            }
            if trainingAvgs == nil {
                trainingAvgs = [TrainingAvg]()
            }
            if planTrainings == nil {
                planTrainings = [PlanTraining]()
            }
            
            let downloadTrainings = DownloadTrainings(sessionIdFrom: sessionId, sessionIdTo: sessionId)
            if let trainingValue = downloadTrainings.run() {
                trainings! += trainingValue
            }
            serverError = downloadTrainings.error
            
            let downloadTrainingAvgs = DownloadTrainingAvgs(sessionIdFrom: sessionId, sessionIdTo: sessionId)
            if let trainingAvgValue = downloadTrainingAvgs.run() {
                trainingAvgs! += trainingAvgValue
            }
            serverError = downloadTrainingAvgs.error
            
            let downloadPlanBySessionId = DownloadPlanTrainingBySessionId(sessionIdFrom: sessionId, sessionIdTo: sessionId)
            if let planValue = downloadPlanBySessionId.run() {
                planTrainings! += planValue
            }
            serverError = downloadPlanBySessionId.error
        }*/
        
        return nil
    }
    
    override func deleteDataFromLocale() {
        //nothing here
    }
    
    override func addDataToLocale(data: [SumTrainingNew]?) {
        //TODO: save sumTraining
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
    
    override func getCacheTime() -> Double {
        return 0
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
    
    private func getSumTrainingBySessionId(sessionId: Double) -> SumTrainingNew? {
        return sumTrainingDbLoader.getSumTrainingBySessionId(sessionId: sessionId)
    }

}
