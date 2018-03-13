//
//  ManagerDownloadTrainingNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 25..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

//TODO: unitTest
class ManagerDownloadTraining: ManagerDownload<[SumTraining]> {
    
    private var timestampObject: TimestampObject
    private var localeSessionIds: [Double]?
    private var serverSessionIds: [Double]?
    
    init(timestampObject: TimestampObject) {
        self.timestampObject = timestampObject
        
        self.localeSessionIds = timestampObject.timestampsLocale
        self.serverSessionIds = timestampObject.timestampsServer
    }
    
    override func getData() -> [SumTraining]? {
        downloadTrainings()
        
        if localeSessionIds != nil {
            if serverSessionIds != nil {
                localeSessionIds!.append(contentsOf: serverSessionIds!)
            }
        } else {
            localeSessionIds = serverSessionIds
        }
        
        if serverError == nil {
            serverSessionIds = nil //all data cached, so no more serverSessionIds
        }
        
        timestampObject.timestampsLocale = localeSessionIds
        timestampObject.timestampsServer = serverSessionIds
        
        return SumTrainingDbLoader.sharedInstance.getSumTrainingsBySessionId(sessionIds: localeSessionIds)
    }
    
    private func downloadTrainings() {
        if let serverSessionIds = serverSessionIds {
            let downloadSumTrainings = DownloadSumTrainingsBySessionIds(sessionIds: serverSessionIds)
            let sumTrainings = downloadSumTrainings.run()
            serverError = downloadSumTrainings.error
            
            if serverError != nil {
                return
            }
            
            let downloadTrainingAvgs = DownloadTrainingAvgsBySessionIds(sessionIds: serverSessionIds)
            let avgTrainings = downloadTrainingAvgs.run()
            serverError = downloadTrainingAvgs.error
            
            if serverError != nil {
                return
            }
            
            let downloadTrainings = DownloadTrainingsBySessionIds(sessionIds: serverSessionIds)
            let trainings = downloadTrainings.run()
            serverError = downloadTrainings.error
            
            if serverError != nil {
                return
            }
            
            let downloadPlans = DownloadPlanTrainingBySessionIds(sessionIds: serverSessionIds)
            let plans = downloadPlans.run()
            serverError = downloadPlans.error
            
            if serverError != nil {
                return
            }
            
            if sumTrainings != nil && avgTrainings != nil && trainings != nil {
                SumTrainingDbLoader.sharedInstance.addSumTrainings(sumTrainings: sumTrainings!)
                TrainingAvgDbLoader.sharedInstance.addTrainingAvgs(trainingAvgs: avgTrainings!)
                TrainingDbLoader.sharedInstance.addTrainings(trainings: trainings!)
                
                if let plans = plans {
                    PlanTrainingDbLoader.sharedInstance.addPlanTrainings(planTrainings: plans)
                }
            }
        }
    }
    
    override func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadTraining
    }
    
}
