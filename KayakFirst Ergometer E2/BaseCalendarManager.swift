//
//  BaseCalendarManager.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseCalendarManager<E>: BaseManager {
    
    //MARK: callback
    var dataListCallback: ((_ data: [E]?, _ error: Responses?) -> ())?
    var daysCallback: ((_ data: DaysObject?, _ error: Responses?) -> ())?
    
    func getDays() -> BaseManagerType {
        fatalError("must be implemented")
    }
    
    func getDataList(localeTimestamps: [Double]?, serverTimestamps: [Double]?) -> BaseManagerType {
       fatalError("must be implemented")
    }
    
}
