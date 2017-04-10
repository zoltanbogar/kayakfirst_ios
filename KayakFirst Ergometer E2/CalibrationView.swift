//
//  CalibrationView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 04. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

public protocol CalibrationDelegate {
    func onCalibrationEnd()
}

class CalibrationView: UIView {
    
    //MARK: properties
    private let view = UIView()
    var delegate: CalibrationDelegate?
    
    //MARK: init
    init(superView: UIView) {
        super.init(frame: superView.frame)
        
        view.backgroundColor = Colors.startDelayBackground
        
        view.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { make in
            make.center.equalTo(view)
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
    
    func showView() {
        show(true)
    }
    
    private func startTimer() {
        let startTime = currentTimeMillis()
        var timeDiff: Double = 0
        
        DispatchQueue.global().async {
            while timeDiff < analyzeTime {
                usleep(10000)
                timeDiff = currentTimeMillis() - startTime
                DispatchQueue.main.async {
                    //TODO: update progressBar
                }
            }
            DispatchQueue.main.async {
                self.show(false)
            }
        }
        
    }
    
    //MARK: show view
    private func show(_ isShow: Bool) {
        if isShow {
            startTimer()
        } else {
            if let delegateValue = delegate {
                delegateValue.onCalibrationEnd()
            }
        }
        
        view.isHidden = !isShow
    }
    
    //MARK: init view
    private func initView() {
        view.addSubview(labelTitle)
    }
    
    //MARK: views
    private lazy var labelTitle: UILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Colors.colorPrimary
        
        label.text = "Calibrating..."
        
        return label
    }()
    
}
