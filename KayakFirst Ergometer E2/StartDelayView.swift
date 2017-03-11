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

//TODO: design
class StartDelayView: UIView {
    
    //MARK: constants
    private let countTime = 30
    
    //MARK: properties
    private let view = UIView()
    var delegate: StartDelayDelegate?
    private var timer: Timer?
    private var timeInSeconds: Int = 0
    
    init(superView: UIView) {
        super.init(frame: superView.frame)
        
        view.backgroundColor = Colors.startDelayBackground
        
        view.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { make in
            make.top.equalTo(view).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
            make.centerX.equalTo(view)
        }
        
        view.addSubview(labelDelay)
        labelDelay.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        view.addSubview(btnQuickStart)
        btnQuickStart.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).inset(UIEdgeInsetsMake(0, 0, margin2, 0))
        }
        
        superView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalTo(superView)
        }
        
        show(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: show view
    func show(_ isShow: Bool) {
        view.isHidden = !isShow
        startCounter(isShow)
    }
    
    private func startCounter(_ isStart: Bool) {
        if isStart {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timeInSeconds = 0
            
            if let delegateValue = delegate {
                delegateValue.onCounterEnd()
            }
        }
    }
    
    @objc private func timerUpdate() {
        timeInSeconds = timeInSeconds + 1
        
        labelDelay.text = "\(countTime - timeInSeconds)"
        
        //the 0 number is has to be shown (countTime + 1)
        if timeInSeconds == countTime + 1 {
            show(false)
        }
        
    }
    
    //MARK: views
    private func initView() {
        view.addSubview(labelTitle)
        
    }
    
    private lazy var labelTitle: UILabel! = {
        let label = AppUILabel()
        
        label.text = getString("delay_start_seconds")
        
        return label
    }()
    
    private lazy var labelDelay: UILabel! = {
        let label = AppUILabel()
        
        label.text = "\(self.countTime)"
        
        return label
    }()
    
    private lazy var btnQuickStart: UIButton! = {
        let width = self.frame.width - margin2
        let button = AppUIButton(width: width, text: getString("delay_quick_start"), backgroundColor: Colors.colorWhite, textColor: Colors.colorAccent)
        button.addTarget(self, action: #selector(btnQuickStartClick), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: button listener
    @objc private func btnQuickStartClick() {
        show(false)
    }
    
}
