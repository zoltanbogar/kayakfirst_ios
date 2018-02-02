//
//  RefreshDashboardHelper.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 15..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

protocol RefresDashboardHelperDelegate {
    func refreshUi()
}

class RefreshDashboardHelper {
    
    //MARK: properties
    private var timer: Timer?
    private var delegate: RefresDashboardHelperDelegate?
    
    private var shouldActive: Bool = false
    private var onResumed: Bool = false
    
    //MARK: init
    private static var instance: RefreshDashboardHelper?
    
    class func getInstance(delegate: RefresDashboardHelperDelegate) -> RefreshDashboardHelper {
        if RefreshDashboardHelper.instance == nil {
            RefreshDashboardHelper.instance = RefreshDashboardHelper(delegate: delegate)
        }
        RefreshDashboardHelper.instance?.delegate = delegate
        return RefreshDashboardHelper.instance!
    }
    
    private init(delegate: RefresDashboardHelperDelegate) {
        self.delegate = delegate
    }
    
    //MARK: functions
    func cycleResume() {
        shouldActive = true
        startRefresh(true)
    }
    
    func cyclePause() {
        shouldActive = false
        startRefresh(false)
    }
    
    func cycleStop() {
        cyclePause()
        refresh()
    }
    
    func onResume() {
        onResumed = true
        startRefresh(true)
    }
    
    func onPause() {
        onResumed = false
        startRefresh(false)
    }
    
    //MARK: functions
    func startRefresh(_ isStart: Bool) {
        timer?.invalidate()
        if isStart && shouldActive && onResumed {
            timer = Timer.scheduledTimer(timeInterval: (refreshMillis / 1000), target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func refresh() {
        delegate?.refreshUi()
    }
    
}
