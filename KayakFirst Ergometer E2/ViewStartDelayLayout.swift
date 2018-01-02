//
//  ViewStartDelayLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewStartDelayLayout: BaseLayout {
    
    private let frame: CGRect
    
    init(contentView: UIView, frame: CGRect) {
        self.frame = frame
        super.init(contentView: contentView)
    }
    
    override func setView() {
        contentView.backgroundColor = Colors.startDelayBackground
        
        contentView.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(margin2, 0, 0, 0))
            make.width.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
        
        contentView.addSubview(btnQuickStart)
        btnQuickStart.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, margin2, 0))
            make.height.equalTo(buttonHeight)
            make.width.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin2, 0, margin2))
        }
        
        contentView.addSubview(labelDelay)
        labelDelay.snp.makeConstraints { make in
            make.center.equalTo(contentView)
            make.top.equalTo(labelTitle.snp.bottom).inset(UIEdgeInsetsMake(0, 0, -margin, 0))
            make.bottom.equalTo(btnQuickStart.snp.top).inset(UIEdgeInsetsMake(-margin, 0, 0, 0))
        }
        
    }
    
    //MARK: views
    lazy var labelTitle: UILabel! = {
        let label = AppUILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Colors.colorPrimary
        
        label.text = getString("delay_start_seconds").uppercased()
        
        return label
    }()
    
    lazy var labelDelay: UILabel! = {
        let label = LabelWithAdaptiveTextHeight()
        label.textColor = Colors.colorPrimary
        
        return label
    }()
    
    lazy var btnQuickStart: UIButton! = {
        let width = self.frame.width - margin2
        let button = AppUIButton(width: width, text: getString("delay_quick_start"), backgroundColor: Colors.colorPrimary, textColor: Colors.colorAccent)
        
        return button
    }()
    
}
