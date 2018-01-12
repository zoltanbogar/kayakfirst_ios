//
//  ViewDashboardElementLayout.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2018. 01. 02..
//  Copyright © 2018. Balazs Vidumanszki. All rights reserved.
//

import Foundation

class ViewDashboardElementLayout: BaseLayout {
    
    override func setView() {
        contentView.addSubview(labelTitle)
        contentView.addSubview(labelValue)
        contentView.addSubview(selectedView)
        selectedView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        contentView.backgroundColor = Colors.colorPrimary
        initPortrait()
    }
    
    func initPortrait() {
        labelTitle.snp.removeConstraints()
        labelValue.snp.removeConstraints()
        labelTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(UIEdgeInsetsMake(margin05, 0, 0, 0))
            make.centerX.equalTo(contentView)
            var height = contentView.frame.height / 3
            if height == 0 {
                height = 30
            }
            make.height.equalTo(height)
            make.width.equalTo(contentView)
        }
        
        labelValue.snp.makeConstraints { make in
            make.top.equalTo(labelTitle.snp.bottom)
            make.bottom.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
    }
    
    func initLandscape() {
        let width = contentView.frame.width
        
        labelTitle.snp.removeConstraints()
        labelValue.snp.removeConstraints()
        labelTitle.snp.makeConstraints { make in
            make.left.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin05, 0, 0))
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView)
            make.width.equalTo(width * 0.3)
        }
        
        labelValue.snp.makeConstraints { make in
            make.left.equalTo(labelTitle.snp.right)
            make.centerY.equalTo(contentView).inset(UIEdgeInsetsMake(0, margin, 0, 0))
            make.height.equalTo(contentView)
            make.width.equalTo(width * 0.7)
        }
    }
    
    lazy var labelTitle: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        
        label.textColor = Colors.colorWhite
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    lazy var labelValue: UILabel! = {
        let label = LabelWithAdaptiveTextHeight(maxFontSize: 200)
        label.textAlignment = .center
        label.textColor = Colors.colorWhite
        
        label.font = UIFont(name: "BebasNeue", size: 94)
        
        return label
    }()
    
    lazy var selectedView: UIView! = {
        let view = UIView()
        
        view.backgroundColor = Colors.dragDropStart
        
        view.isHidden = true
        
        return view
    }()
    
}
