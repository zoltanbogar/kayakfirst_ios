//
//  ManagerDownloadEventDays.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 07. 05..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ManagerDownloadEventDays: ManagerDownloadPlan<[Double]>, ManagerDownloadProtocol {
    
    override func getDataFromLocale() -> [Double]? {
        return eventDbLoader.getEventDays()
    }
    
    func isEqual(anotherManagerDownload: ManagerDownloadProtocol) -> Bool {
        return anotherManagerDownload is ManagerDownloadEventDays
    }
    
}
