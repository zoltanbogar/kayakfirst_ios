//
//  BaseCalendarDateHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 02. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class BaseCalendarDateHelper<LAYOUT: BaseLayout, DATA>: CalendarDelegate {
    
    private let calendarVc: CalendarVc
    private let calendarView: CalendarView
    private let listView: BaseCalendarListView<LAYOUT, DATA>
    
    private var daysList: [Double]? = nil
    
    private var viewVisible = false
    
    var selectedDate: Double = 0
    
    init(calendarVc: CalendarVc, calendarView: CalendarView, listView: BaseCalendarListView<LAYOUT, DATA>, clickCallback: ((_ data: [DATA]?, _ position: Int) -> ())?) {
        self.calendarVc = calendarVc
        self.calendarView = calendarView
        self.listView = listView
        
        listView.initTableView(dataHelper: self, clickCallback: clickCallback, deleteCallback: deleteDataCallback)
        
        getManager().daysCallback = daysCallback
        
        selectedDate = calendarView.selectedDate
    }
    
    func getManager() -> BaseCalendarManager<DATA> {
        fatalError("must be implemented")
    }
    
    func show(isShow: Bool, selectedDate: Double) {
        viewVisible = isShow
        self.selectedDate = selectedDate
        
        calendarView.timestamps = nil
        if isShow {
            calendarView.delegate = self
            listView.isHidden = false
            
            getDays()
        } else {
            calendarView.delegate = nil
            listView.isHidden = true
        }
    }
    
    func onDateSelected(timestamp: Double) {
        self.selectedDate = timestamp
        
        getDataList()
    }
    
    func errorHandling(error: Responses?) {
        calendarVc.initError(error: error)
    }
    
    private func getDays() {
        getManager().getDays()
    }
    
    private func initDays(daysList: [Double]) {
        self.daysList = daysList
        
        if viewVisible {
            calendarView.timestamps = daysList
            
            getDataList()
        }
    }
    
    private func getDataList() {
        var timestamps = [Double]()
        
        if let daysList = daysList {
            for timestamp in daysList {
                if DateFormatHelper.isSameDay(timeStamp1: timestamp, timeStamp2: selectedDate) {
                    timestamps.append(timestamp)
                }
            }
        }
        
        listView.showData(timestamps: timestamps, selectedDate: selectedDate)
    }
    
    private func daysCallback(data: [Double]?, error: Responses?) {
        if let data = data {
            initDays(daysList: data)
        }
        
        errorHandling(error: error)
    }
    
    private func deleteDataCallback(data: Bool?, error: Responses?) {
        if data != nil && data! {
            getDays()
        }
        errorHandling(error: error)
    }
    
}
