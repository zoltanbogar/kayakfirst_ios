//
//  ViewCalibrationLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewCalibrationLayout: BaseLayout {
    
    override func setView() {
        contentView.backgroundColor = Colors.colorPrimary
        
        contentView.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(margin2)
        }
        
        contentView.addSubview(imageStop)
        imageStop.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imageLogo.snp.bottom).offset(margin2)
        }
        
        contentView.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imageStop.snp.bottom).offset(margin2)
        }
        
        contentView.addSubview(imageSatelite)
        imageSatelite.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(labelTitle.snp.bottom).offset(margin2)
        }
        
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imageSatelite.snp.bottom).offset(margin2)
            make.left.equalTo(contentView).offset(margin2)
            make.right.equalTo(contentView).offset(-margin2)
            make.height.equalTo(5)
        }
    }
    
    //MARK: views
    lazy var labelTitle: UILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        label.text = getString("dialog_calibrating_sensor")
        
        return label
    }()
    
    lazy var imageLogo: UIImageView! = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "logo_header")
        imageView.image = image
        
        return imageView
    }()
    
    lazy var imageStop: UIImageView! = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "stopTable")
        imageView.image = image
        
        return imageView
    }()
    
    lazy var imageSatelite: UIImageView! = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "satelliteIcon")
        imageView.image = image
        
        return imageView
    }()
    
    lazy var progressView: UIProgressView! = {
        let progressView = UIProgressView()
        
        progressView.tintColor = Colors.colorWhite
        progressView.trackTintColor = Colors.colorTransparent
        
        return progressView
    }()
    
}
