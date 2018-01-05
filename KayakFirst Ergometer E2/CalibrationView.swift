//
//  CalibrationView.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 04. 10..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class CalibrationView: CustomUi<ViewCalibrationLayout> {
    
    //MARK: properties
    private var calibrationDuration: Double!
    
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
    
    override func getContentLayout(contentView: UIView) -> ViewCalibrationLayout {
        return ViewCalibrationLayout(contentView: contentView)
    }
    
    func showView(calibrationDuration: Double) {
        self.calibrationDuration = calibrationDuration
        show(true)
    }
    
    func calibrationEnd() {
        show(false)
    }
    
    private func startTimer() {
        let startTime = currentTimeMillis()
        var timeDiff: Double = 0
        
        DispatchQueue.global().async {
            while timeDiff < self.calibrationDuration {
                usleep(UInt32(refreshMillis * 1000 / 2))
                timeDiff = currentTimeMillis() - startTime
                DispatchQueue.main.async {
                    let percent = timeDiff / self.calibrationDuration
                    self.contentLayout!.progressView.progress = Float(percent)
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
        }
        isHidden = !isShow
    }
    
}
