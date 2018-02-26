//
//  ManagerDownloadPlanByNameNew.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 26..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation
import SQLite

class ManagerDownloadPlanByNameNew: ManagerDownloadPlanNew<[Plan]> {
    
    //MARK: properties
    private let name: String
    
    //MARK: init
    init(name: String) {
        self.name = name
    }
    
    override func getDataFromLocale() -> [Plan]? {
        return planDbLoader.loadData(predicate: getQueryName())
    }
    
    override func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadPlanByNameNew
    }
    
    //MARK: helpers
    private func getQueryName() -> Expression<Bool> {
        return planDbLoader.getNamePredicate(name: name)
    }
    
}
