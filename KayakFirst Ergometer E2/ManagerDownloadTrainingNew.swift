//
//  ManagerDownloadTrainingNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 25..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

//TODO: test
class ManagerDownloadTrainingNew: ManagerDownloadNew<[SumTrainingNew]> {
    
    private var localeSessionIds: [Double]?
    private let serverSessionIds: [Double]?
    
    init(localeSessionIds: [Double]?, serverSessionIds: [Double]?) {
        self.localeSessionIds = localeSessionIds
        self.serverSessionIds = serverSessionIds
    }
    
    override func getData() -> [SumTrainingNew]? {
        downloadTrainings()
        
        if localeSessionIds != nil && serverSessionIds != nil {
            localeSessionIds!.append(contentsOf: serverSessionIds!)
        }
        
        return SumTrainingDbLoader.sharedInstance.getSumTrainingsBySessionId(sessionIds: localeSessionIds)
    }
    
    //TODO: downloadPlan
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
                TrainingAvgNewDbLoader.sharedInstance.addTrainingAvgs(trainingAvgs: avgTrainings!)
                TrainingNewDbLoader.sharedInstance.addTrainings(trainings: trainings!)
                
                if let plans = plans {
                    PlanTrainingDbLoader.sharedInstance.addPlanTrainings(planTrainings: plans)
                }
            }
        }
    }
    
    override func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadTrainingNew
    }
    
}
