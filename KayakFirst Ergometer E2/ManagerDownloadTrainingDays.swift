//
//  ManagerDownloadTrainingDays.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerDownloadTrainingDays: ManagerDownload<[Double]>, ManagerDownloadProtocol {
    
    //MARK: properties
    internal var localeDaysList: [Double]?
    internal var serverDaysList: [Double]?
    
    //MARK: functions
    override func getDataFromLocale() -> [Double]? {
        localeDaysList = TrainingDbLoader.sharedInstance.getTrainingDays()
        return localeDaysList
    }
    
    override func getDataFromServer() -> [Double]? {
        return serverDaysList
    }
    
    override func runServer() -> [Double]? {
        let serverService = getServerService()
        
        serverDaysList = serverService.run()
        
        if localeDaysList != nil && serverDaysList != nil {
            localeDaysList = Array(Set(localeDaysList!).subtracting(serverDaysList!))
            
            for d in localeDaysList! {
                let timestampFrom = DateFormatHelper.getZeroHour(timeStamp: d)
                let timestampTo = DateFormatHelper.get23Hour(timeStamp: d)
                
                deleteDataByTimestamp(timestampFrom: timestampFrom, timestampTo: timestampTo)
            }
        }
        
        serverError = serverService.error
        
        return serverDaysList
    }
    
    internal func getServerService() -> ServerService<[Double]> {
        return DownloadTrainingDays()
    }
    
    internal func deleteDataByTimestamp(timestampFrom: Double, timestampTo: Double) {
        let trainingDbLoader = TrainingDbLoader.sharedInstance
        trainingDbLoader.deleteData(predicate: trainingDbLoader.getTrainingsBetweenSessionIdPredicate(sessionIdFrom: timestampFrom, sessionIdTo: timestampTo))
        
        let trainingAvgDbLoader = TrainingAvgDbLoader.sharedInstance
        trainingAvgDbLoader.deleteData(predicate: trainingAvgDbLoader.getTrainingAvgsBetweenSessionIdPredicate(sessionIdFrom: timestampFrom, sessionIdTo: timestampTo))
        
        let planTrainingDbLoader = PlanTrainingDbLoader.sharedInstance
        planTrainingDbLoader.deleteData(predicate: planTrainingDbLoader.getExpressionSessionId(sessionIdFrom: timestampFrom, sessionIdTo: timestampTo))
    }
    
    override func deleteDataFromLocale() {
        //nothing here
    }
    
    override func addDataToLocale(data: [Double]?) {
        //nothing here
    }
    
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return true
    }
    
    override func getKeyCache() -> String {
        return "manager_download_training_days"
    }
    
    override func getCacheTime() -> Double {
        return 0
    }
    
}
