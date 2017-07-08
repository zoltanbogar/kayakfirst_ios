//
//  ManagerDownloadPlanByName.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class ManagerDownloadPlanByName: ManagerDownload<[Plan]>, ManagerDownloadProtocol {
    
    //MARK: constants
    private let planDbLoader = PlanDbLoader.sharedInstance
    
    //MARK: properties
    private let name: String
    
    //MARK: init
    init(name: String) {
        self.name = name
    }
    
    //MARK: functions
    override func getDataFromLocale() -> [Plan]? {
        return planDbLoader.loadData(predicate: getQueryName())
    }
    
    override func runServer() -> [Plan]? {
        let downloadPlanByName = DownloadPlanByName(name: name)
        let planArrayList = downloadPlanByName.run()
        serverError = downloadPlanByName.error
        
        return planArrayList
    }
    
    override func deleteDataFromLocale() {
        planDbLoader.deleteData(predicate: getQueryName())
    }
    
    override func addDataToLocale(data: [Plan]?) {
        planDbLoader.addPlanList(planList: data!)
    }
    
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadPlanByName &&
        self.name == (anotherManagerDownload as! ManagerDownloadPlanByName).name
    }
    
    override func getKeyCache() -> String {
        return "manager_download_plan_name_\(name)"
    }
    
    //MARK: helpers
    private func getQueryName() -> Expression<Bool> {
        return planDbLoader.getNamePredicate(name: name)
    }
    
    
}
