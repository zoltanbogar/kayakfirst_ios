//
//  RefreshView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 06. 25..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class RefreshView: UIView {
    
    //MARK: constants
    static let refreshMillis: Double = 33
    
    //MARK: properties
    var timer: Timer?
    
    //MARK: abstract functions
    internal func refreshUi() {
        fatalError("must be implemented")
    }
    
    //MARK: functions
    func startRefresh(_ isStart: Bool) {
        if isStart {
            timer = Timer.scheduledTimer(timeInterval: (RefreshView.refreshMillis / 1000), target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
    }
    
    @objc private func refresh() {
        refreshUi()
    }
    
    //MARK: view
    override func layoutSubviews() {
        super.layoutSubviews()
        
        refresh()
    }
}
