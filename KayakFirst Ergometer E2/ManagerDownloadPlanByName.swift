//
//  ManagerDownloadPlanByName.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class ManagerDownloadPlanByName: ManagerDownloadPlan<[Plan]>, ManagerDownloadProtocol {
    
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
    
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadPlanByName
    }
    
    //MARK: helpers
    private func getQueryName() -> Expression<Bool> {
        return planDbLoader.getNamePredicate(name: name)
    }
    
    
}
