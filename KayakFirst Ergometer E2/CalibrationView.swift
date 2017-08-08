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
        
        view.backgroundColor = Colors.colorPrimary
        
        view.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(margin2)
        }
        
        view.addSubview(imageStop)
        imageStop.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(imageLogo.snp.bottom).offset(margin2)
        }
        
        view.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(imageStop.snp.bottom).offset(margin2)
        }
        
        view.addSubview(imageSatelite)
        imageSatelite.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(labelTitle.snp.bottom).offset(margin2)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(imageSatelite.snp.bottom).offset(margin2)
            make.left.equalTo(view).offset(margin2)
            make.right.equalTo(view).offset(-margin2)
            make.height.equalTo(5)
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
                usleep(UInt32(RefreshView.refreshMillis * 1000 / 2))
                timeDiff = currentTimeMillis() - startTime
                DispatchQueue.main.async {
                    let percent = timeDiff / analyzeTime
                    self.progressView.progress = Float(percent)
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
    
    //MARK: views
    private lazy var labelTitle: UILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        label.text = getString("dialog_calibrating_sensor")
        
        return label
    }()
    
    private lazy var imageLogo: UIImageView! = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "logo_header")
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var imageStop: UIImageView! = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "stopTable")
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var imageSatelite: UIImageView! = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "satelliteIcon")
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var progressView: UIProgressView! = {
        let progressView = UIProgressView()
        
        progressView.tintColor = Colors.colorWhite
        
        return progressView
    }()
    
}
