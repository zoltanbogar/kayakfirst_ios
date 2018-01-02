//
//  StartDelayView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 03. 01..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import UIKit

public protocol StartDelayDelegate {
    func onCounterEnd()
}

class StartDelayView: CustomUi {
    
    //MARK: constants
    private let countTime = 30
    
    //MARK: properties
    var delegate: StartDelayDelegate?
    private var timer: Timer?
    private var timeInSeconds: Int = 0
    
    //MARK: init
    init(superView: UIView) {
        super.init()
        
        superView.addSubview(contentLayout!.contentView)
        contentLayout!.contentView.snp.makeConstraints { make in
            make.edges.equalTo(superView)
        }
        
        show(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getContentLayout(contentView: UIView) -> BaseLayout {
        return ViewStartDelayLayout(contentView: contentView, frame: self.frame)
    }
    
    override func initView() {
        super.initView()
        
        (contentLayout as! ViewStartDelayLayout).labelDelay.text = "\(self.countTime)"
        (contentLayout as! ViewStartDelayLayout).btnQuickStart.addTarget(self, action: #selector(btnQuickStartClick), for: .touchUpInside)
    }
    
    //MARK: show view
    func show(_ isShow: Bool) {
        startCounter(isShow)
        isHidden = !isShow
    }
    
    private func startCounter(_ isStart: Bool) {
        if isStart {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timeInSeconds = 0
            (contentLayout as! ViewStartDelayLayout).labelDelay.text = "\(countTime)"
            
            if let delegateValue = delegate {
                delegateValue.onCounterEnd()
            }
        }
    }
    
    @objc private func timerUpdate() {
        timeInSeconds = timeInSeconds + 1
        
        (contentLayout as! ViewStartDelayLayout).labelDelay.text = "\(countTime - timeInSeconds)"
        
        //the 0 number is has to be shown (countTime + 1)
        if timeInSeconds == countTime + 1 {
            show(false)
        }
        
    }
    
    //MARK: button listener
    @objc private func btnQuickStartClick() {
        show(false)
    }
    
}
