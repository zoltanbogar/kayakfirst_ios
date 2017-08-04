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
    private let sessionIdFrom: Double
    private let sessionIdTo: Double
    
    //MARK: init
    init(sessionIdFrom: Double, sessionIdTo: Double) {
        self.sessionIdFrom = sessionIdFrom
        self.sessionIdTo = sessionIdTo
    }
    
    //MARK: functions
    override func getDataFromLocale() -> [SumTraining]? {
        let trainings = trainingDbLoader.loadData(predicate: getQueryTraining())
        
        let trainingAvgs = trainingAvgDbLoader.loadData(predicate: getQueryTrainingAvg())
        let avgTrainingHashMap = putTrainingAvgsToMap(avgs: trainingAvgs)
        
        var planTrainings: [PlanTraining]? = nil
        if getQueryPlan() != nil {
            planTrainings = planTrainingDbLoader.loadData(predicate: getQueryPlan())
        }
        let planHashMap = putPlanToMap(planList: planTrainings)

        return getSumTrainingList(trainings: trainings, avgTrainingHashMap: avgTrainingHashMap, planHashMap: planHashMap)
    }
    
    override func runServer() -> [SumTraining]? {
        let downloadTrainings = DownloadTrainings(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)
        let trainings = downloadTrainings.run()
        serverError = downloadTrainings.error
        
        let downloadTrainingAvgs = DownloadTrainingAvgs(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)
        let trainingAvgs = downloadTrainingAvgs.run()
        let avgTrainingHashMap = putTrainingAvgsToMap(avgs: trainingAvgs)
        serverError = downloadTrainingAvgs.error
        
        let downloadPlanBySessionId = DownloadPlanTrainingBySessionId(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)
        let planTrainings = downloadPlanBySessionId.run()
        let planHashMap = putPlanToMap(planList: planTrainings)
        serverError = downloadPlanBySessionId.error
        
        return getSumTrainingList(trainings: trainings, avgTrainingHashMap: avgTrainingHashMap, planHashMap: planHashMap)
    }
    
    override func deleteDataFromLocale() {
        trainingDbLoader.deleteData(predicate: getQueryTraining())
        trainingAvgDbLoader.deleteData(predicate: getQueryTrainingAvg())
        planTrainingDbLoader.deleteData(predicate: getQueryPlan())
    }
    
    override func addDataToLocale(data: [SumTraining]?) {
        if let sumTrainingList = data {
            for sumTraining in sumTrainingList {
                trainingDbLoader.addTrainings(trainings: sumTraining.t200List)
                trainingDbLoader.addTrainings(trainings: sumTraining.t500List)
                trainingDbLoader.addTrainings(trainings: sumTraining.t1000List)
                trainingDbLoader.addTrainings(trainings: sumTraining.strokesList)
                trainingDbLoader.addTrainings(trainings: sumTraining.fList)
                trainingDbLoader.addTrainings(trainings: sumTraining.vList)
                trainingDbLoader.addTrainings(trainings: sumTraining.distanceList)
                
                if sumTraining.trainingAvgT200 != nil {
                    trainingAvgDbLoader.addData(data: sumTraining.trainingAvgT200!)
                }
                if sumTraining.trainingAvgT500 != nil {
                    trainingAvgDbLoader.addData(data: sumTraining.trainingAvgT500!)
                }
                if sumTraining.trainingAvgT1000 != nil {
                    trainingAvgDbLoader.addData(data: sumTraining.trainingAvgT1000!)
                }
                if sumTraining.trainingAvgStrokes != nil {
                    trainingAvgDbLoader.addData(data: sumTraining.trainingAvgStrokes!)
                }
                if sumTraining.trainingAvgF != nil {
                    trainingAvgDbLoader.addData(data: sumTraining.trainingAvgF!)
                }
                if sumTraining.trainingAvgV != nil {
                    trainingAvgDbLoader.addData(data: sumTraining.trainingAvgV!)
                }
                
                if sumTraining.planTraining != nil {
                    planTrainingDbLoader.addData(data: sumTraining.planTraining!)
                }
            }
        }
    }
    
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadTrainingBySessionId &&
        (anotherManagerDownload as! ManagerDownloadTrainingBySessionId).sessionIdFrom == self.sessionIdFrom &&
        (anotherManagerDownload as! ManagerDownloadTrainingBySessionId).sessionIdTo == self.sessionIdTo
    }
    
    override func getKeyCache() -> String {
        return "manager_download_training_sessionid_\(sessionIdFrom)_\(sessionIdTo)"
    }
    
    //MARK: helper
    private func putTrainingAvgsToMap(avgs: [TrainingAvg]?) -> [String : TrainingAvg]? {
        var avgTrainingHashMap: [String : TrainingAvg]? = nil
        if let trainingAvgs = avgs {
            avgTrainingHashMap = [String : TrainingAvg]()
            for trainingAvg in trainingAvgs {
                avgTrainingHashMap?.updateValue(trainingAvg, forKey: trainingAvg.avgHash)
            }
        }
        return avgTrainingHashMap
    }
    
    private func putPlanToMap(planList: [PlanTraining]?) -> [Double : PlanTraining]? {
        var hashMap: [Double : PlanTraining]? = nil
        
        if let planListValue = planList {
            hashMap = [Double : PlanTraining]()
            for planTraining in planListValue {
                hashMap?.updateValue(planTraining, forKey: planTraining.sessionId)
            }
        }
        return hashMap
    }
    
    private func getSumTrainingList(trainings: [Training]?, avgTrainingHashMap: [String : TrainingAvg]?, planHashMap: [Double : PlanTraining]?) -> [SumTraining]? {
        if trainings != nil {
            return SumTraining.Builder.init(trainings: trainings!, avgTrainingHashMap: avgTrainingHashMap, planHashMap: planHashMap).createSumTrainingList()
        } else {
            return nil
        }
    }
    
    private func getQueryTraining() -> Expression<Bool> {
        return trainingDbLoader.getTrainingsBetweenSessionIdPredicate(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)
    }
    
    private func getQueryTrainingAvg() -> Expression<Bool> {
        return trainingAvgDbLoader.getTrainingAvgsBetweenSessionIdPredicate(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)
    }
    
    private func getQueryPlan() -> Expression<Bool>? {
        return planTrainingDbLoader.getExpressionSessionId(sessionIdFrom: sessionIdFrom, sessionIdTo: sessionIdTo)
    }
    
}
