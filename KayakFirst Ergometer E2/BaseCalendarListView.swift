//
//  BaseCalendarListView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseCalendarListView<LAYOUT: BaseLayout, DATA>: CustomUi<LAYOUT> {
    
    private var dataHelper: BaseCalendarDateHelper<LAYOUT, DATA>?
    
    private var tableView: BaseCalendarTableView<DATA>?
    
    private var selectedDate: Double = 0
    
    override init() {
        super.init()
        getManager().dataListCallback = listCallback
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: abstract functions
    func getTableView() -> BaseCalendarTableView<DATA> {
        fatalError("must be implemented")
    }
    
    func getProgressBar() -> AppProgressBar {
        fatalError("must be implemented")
    }
    
    func getManager() -> BaseCalendarManager<DATA> {
        fatalError("must be implemented")
    }
    
    func getDataTimestampToCheck(data: DATA) -> Double {
        fatalError("must be implemented")
    }
    
    func initTableView(dataHelper: BaseCalendarDateHelper<LAYOUT, DATA>, clickCallback: ((_ data: [DATA]?, _ position: Int) -> ())?, deleteCallback: ((_ data: Bool?, _ error: Responses?) -> ())?) {
        self.dataHelper = dataHelper
        
        tableView = getTableView()
        tableView?.clickCallback = clickCallback
        tableView?.deleteCallback = deleteCallback
    }
    
    func showData(selectedDate: Double, timestampObject: TimestampObject?) {
        self.selectedDate = selectedDate
        
        tableView?.dataList = nil
        
        if let timestampObject = timestampObject {
            if (timestampObject.timestampsServer != nil && timestampObject.timestampsServer!.count > 0) || (timestampObject.timestampsLocale != nil && timestampObject.timestampsLocale!.count > 0) {
                getProgressBar().showProgressBar(true)
                getManager().getDataList(timestampObject: timestampObject)
            } else {
                getProgressBar().showProgressBar(false)
            }
        }
    }
    
    func listCallback(data: [DATA]?, error: Responses?) {
        getProgressBar().showProgressBar(false)
        
        if data != nil && data!.count > 0 {
            if isDataCorrectDay(timestamp: getDataTimestampToCheck(data: data![0])) {
                tableView?.dataList = data
            }
        } else {
            tableView?.dataList = nil
        }
        
        dataHelper?.errorHandling(error: error)
    }
    
    private func isDataCorrectDay(timestamp: Double) -> Bool {
        return DateFormatHelper.isSameDay(timeStamp1: timestamp, timeStamp2: self.selectedDate)
    }
    
}
