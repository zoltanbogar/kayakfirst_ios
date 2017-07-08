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
    internal var daysList: [Double]?
    
    //MARK: functions
    override func getDataFromLocale() -> [Double]? {
        return TrainingDbLoader.sharedInstance.getTrainingDays()
    }
    
    override func getDataFromServer() -> [Double]? {
        return daysList
    }
    
    override func runServer() -> [Double]? {
        let downloadTrainingDays = DownloadTrainingDays()
        
        daysList = downloadTrainingDays.run()
        
        serverError = downloadTrainingDays.error
        
        return daysList
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
